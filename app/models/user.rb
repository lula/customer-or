class User
  include Mongoid::Document
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :rememberable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :trackable, :validatable, 
         :lockable, :timeoutable

  ## Database authenticatable
  field :username, type: String
  field :email,              :type => String, :default => ""
  field :encrypted_password, :type => String, :default => ""

  ## Recoverable
  field :reset_password_token,   :type => String
  field :reset_password_sent_at, :type => Time

  ## Rememberable
  # field :remember_created_at, :type => Time

  ## Trackable
  field :sign_in_count,      :type => Integer, :default => 0
  field :current_sign_in_at, :type => Time
  field :last_sign_in_at,    :type => Time
  field :current_sign_in_ip, :type => String
  field :last_sign_in_ip,    :type => String

  ## Confirmable
  # field :confirmation_token,   :type => String
  # field :confirmed_at,         :type => Time
  # field :confirmation_sent_at, :type => Time
  # field :unconfirmed_email,    :type => String # Only if using reconfirmable

  ## Lockable
  field :failed_attempts, :type => Integer, :default => 0 # Only if lock strategy is :failed_attempts
  field :unlock_token,    :type => String # Only if unlock strategy is :email or :both
  field :locked_at,       :type => Time

  ## Token authenticatable
  # field :authentication_token, :type => String
  
  field :created_at, type: Date, default: Time.now
  field :name, type: String
  
  belongs_to :representative
  
  index({ representative: 1 }, { unique: true, name: "representative_index" })
  
  validates_uniqueness_of :representative, if: ->(user){ !user.representative.nil? }
  validates_presence_of :email
  
  
  def lock
    self.locked_at = Time.now
    self.failed_attempts = Devise.maximum_attempts
  end
  
  def unlock
    self.locked_at = nil
    self.failed_attempts = 0
  end
  
  def admin?
    false
  end
  
end
