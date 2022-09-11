class User < ApplicationRecord

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[facebook google_oauth2 github]
         

  has_many :identities, dependent: :destroy
        
  #statement che associa un user a più gruppi          
  has_many :groups, dependent: :destroy
  has_many :partecipations, dependent: :destroy
  has_one_attached :avatar, dependent: :purge_later
  has_many :events, dependent: :destroy
  has_many :posts, dependent: :destroy

  has_many :notifications, as: :recipient, dependent: :destroy
  has_many :answer, dependent: :destroy
  #Valido la presenza e l'unicità dei campi dell'utente:
  validates :name, presence: true
  validates :surname, presence: true
  validates :username, presence: true, uniqueness: true
  validates :birthday, presence: true
  validates :avatar, blob: { content_type: %r{^image/}, size_range: 0..5.megabytes }

  scope :get_provider_account , -> (user_id,auth_provider_id) { Identity.where("user_id = ? and authentication_provider_id = ? ",user_id,auth_provider_id) }

  after_create :send_email

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
    iden = Identity.where(provider: auth.provider, uid: auth.uid).first
    if iden.nil?
      user = User.new()
      user.name = auth[:info][:first_name]
      user.surname = auth[:info][:last_name]
      user.email = auth.info.email

      if (auth.provider === "facebook")
        user.birthday = auth.extra.raw_info.birthday.split('/').rotate(-1).reverse.join('-')
      elsif (auth.provider === "github")
        user.name = auth[:info][:name]
        user.username = auth[:info][:nickname]
      elsif (auth.provider === "google_oauth2")
        user.access_token = auth.credentials.token
        user.expires_at = auth.credentials.expires_at
        user.refresh_token = auth.credentials.refresh_token
        resp = HTTParty.get("https://people.googleapis.com/v1/people/me?personFields=birthdays&alt=json&key="+Rails.application.credentials.dig(:google, :google_api_key)+"&access_token="+user.access_token)
        json = JSON.parse(resp.body, symbolize_names: true)
        #date = json[:birthdays][0][:date]
       # user.birthday = date[:year].to_s+"-"+date[:month].to_s+"-"+date[:month].to_s
        #user.birthday = HTTParty.get("https://people.googleapis.com/v1/people/"+user.uid.to_s+"?personFields=birthday&key="+Rails.application.credentials.dig(:google, :google_api_key)+"&access_token="+user.access_token)
      end
    else
      user = iden.user
    end
    user
  end

  private 

  def purge_avatar
    unless avatar.nil?
    avatar.purge
    end
  end


  def update_token 
    client = Google::Apis::CalendarV3::CalendarService.new
    return unless (current_user.present? && current_user.access_token.present? && current_user.refresh_token.present?)
    
    secrets = Google::APIClient::ClientSecrets.new({
      "web" => {
        "access_token" => current_user.access_token,
        "refresh_token" => current_user.refresh_token,
        "client_id" => ENV["GOOGLE_CLIENT_ID"],
        "client_secret" => ENV["GOOGLE_CLIENT_SECRET"]
      }
    })
    begin
      client.authorization = secrets.to_authorization
      client.authorization.grant_type = "refresh_token"

      if !current_user.present?
        client.authorization.refresh!
        current_user.update_attributes(
          access_token: client.authorization.access_token,
          refresh_token: client.authorization.refresh_token,
          expires_at: client.authorization.expires_at.to_i
        )
      end
    rescue => e
      flash[:error] = 'Your token has been expired. Please login again with google.'
      redirect_to :back
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
  
  def expired?
    expires_at < Time.current.to_i
  end

  def for_display
    {
    email: email,
    id: id,
    }
  end

  def send_email
    GroupMailer.with(user: self).registration.deliver_later
  end

end