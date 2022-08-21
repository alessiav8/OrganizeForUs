class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[facebook google_oauth2 github]
         


        
  #statement che associa un user a più gruppi          
  has_many :groups
  has_many :partecipations
  has_one_attached :avatar, dependent: :purge_later
  has_many :events

  has_many :notifications, as: :recipient, dependent: :destroy
  has_many :answer, dependent: :destroy
  #Valido la presenza e l'unicità dei campi dell'utente:
  validates :name, presence: true
  validates :surname, presence: true
  validates :username, presence: true, uniqueness: true
  validates :birthday, presence: true
  validates :avatar, blob: { content_type: %r{^image/}, size_range: 0..5.megabytes }


  # Active Storage
  AVATAR_SIZES = {
    thumbnail: [20, 20],
    medium: [50, 50],
    wire: [65, 65],
    large: [200, 200]
  }.freeze

  def profile_avatar_url(size=nil)
    url_for(self.avatar, PICTURE_SIZES.fetch(size, nil))
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_initialize do |user|
      user.name = auth[:info][:first_name]
      user.surname = auth[:info][:last_name]
      user.email = auth.info.email
      user.access_token = auth.credentials.token
      user.expires_at = auth.credentials.expires_at
      user.refresh_token = auth.credentials.refresh_token

      if (auth.provider === "facebook")
        user.birthday = auth.extra.raw_info.birthday.split('/').rotate(-1).reverse.join('-')
      elsif (auth.provider === "github")
        user.name = auth[:info][:name]
        user.username = auth[:info][:nickname]
      elsif (auth.provider === "google_oauth2")
        resp = HTTParty.get("https://people.googleapis.com/v1/people/me?personFields=birthdays&alt=json&key="+Rails.application.credentials.dig(:google, :google_api_key)+"&access_token="+user.access_token)
        json = JSON.parse(resp.body, symbolize_names: true)
        date = json[:birthdays][0][:date]
        user.birthday = date[:year].to_s+"-"+date[:month].to_s+"-"+date[:month].to_s
        #user.birthday = HTTParty.get("https://people.googleapis.com/v1/people/"+user.uid.to_s+"?personFields=birthday&key="+Rails.application.credentials.dig(:google, :google_api_key)+"&access_token="+user.access_token)
      end
    end
  end

  private 

  def purge_avatar
    unless avatar.nil?
    avatar.purge
    end
  end

  def attach_avatar
    file = user_params[:avatar]
    filename = filename = 'OrganizeForUs_'+SecureRandom.hex(5)+'_Upimage.'+(file.content_type.split("/")[1])
    blob = ActiveStorage::Blob.create_and_upload!(io: user_params[:avatar], filename: filename, content_type: file.content_type)
    session[:blob_id] = blob.id
  end

  def grab_image
    avatar.attach(io: URI.open(auth_image_url), filename: 'OrganizeForUs_'+SecureRandom .hex(5)+'_fbimage.png', content_type: "image/png")
  end

  def url_for(image, size=nil)
    url_helpers.rails_representation_url(image.variant(resize_to_fill: size).processed, only_path: true)
  end

  def check_subscription(group)
    if Partecipation.where(group_id: group).select(:user_id).where(user_id: self.id).empty?
      return false
    else 
      return true
    end
  end

end
