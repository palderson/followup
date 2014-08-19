class User < ActiveRecord::Base
	  has_many :friendships
	  has_many :friends, :through => :friendships
	  has_many :inverse_friendships, :class_name => "Friendship", :foreign_key => "friend_id"
	  has_many :inverse_friends, :through => :inverse_friendships, :source => :user
  	# Include default devise modules. Others available are:
  	# :confirmable, :lockable, :timeoutable and :omniauthable

    devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :authentication_keys => [:login]
  
    validates_uniqueness_of :username
    validates_presence_of :username
    validates :username, length: { in: 4..20 }
  
    def self.find_for_database_authentication(warden_conditions)
      conditions = warden_conditions.dup
      if login = conditions.delete(:login)
        where(conditions).where(["username = :value OR lower(email) = lower(:value)", { :value => login }]).first
      else
        where(conditions).first
      end
    end
  
    attr_accessor :login

  	scope :friend_with, ->( other ) do
  	  other = other.id if other.is_a?( User )
  	  where( '(friendships.user_id = users.id AND friendships.friend_id = ?) OR (friendships.user_id = ? AND friendships.friend_id = users.id)', other, other ).includes( :frienships )
  	end
  	def friend_with( other )
  	  User.where( id: id ).friend_with( other ).any?
  	end     
end
