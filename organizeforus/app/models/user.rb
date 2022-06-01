class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, :omniauth_providers => [:facebook]
         
  #statement che associa un user a più gruppi          
  has_many :groups
  has_one_attached :avatar, dependent: :purge_later


  #Valido la presenza e l'unicità dei campi dell'utente:
  validates :name, presence: true
  validates :surname, presence: true
  validates :username, presence: true, uniqueness: true
  validates :birthday, presence: true


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
      user.birthday = auth.extra.raw_info.birthday.split('/').rotate(-1).reverse.join('-')
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

 

=begin
def auth_avatar_attach(auth, url)
  return unless !auth.info.picture.present?
  imagename = File.basename(url.path)
  image = URI.open
  this.avatar.attach(io: image, filename: filename)
end


 
    
  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end
=end
end
