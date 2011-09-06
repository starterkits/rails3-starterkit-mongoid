class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include OauthProvider::User

  field :username,      type: String, index: true
  field :name,          type: String
  field :first_name,    type: String
  field :last_name,     type: String
  field :nickname,      type: String
  field :bio,           type: String
  field :image_url,     type: String
  field :location_name, type: String
  field :verified,      type: Boolean

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :authentications

  after_save :save_authentications

  # called by devise
  def password_required?
    (authentications.empty? || !password.blank?) && super
  end

  protected

  # save any unsaved authentications
  # HACK: Mongoid should be doing this but it's not as of 2.2.0
  def save_authentications
    authentications.each {|auth| auth.save! if auth.new_record? }
  end
end
