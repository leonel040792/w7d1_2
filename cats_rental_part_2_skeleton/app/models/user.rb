# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  username        :string           not null
#  session_token   :string           not null
#  password_digest :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class User < ApplicationRecord
    validates :username, presence: true, uniqueness: true
    validates :password, length: { minium: 6, allow_nil: true}
    validates :password_digest, presence: true 
    validates :session_token, presence: true, uniqueness: true
    after_initialize :ensure_session_token


    def self.find_by_credentials(user_name, password)
        user = User.find_by(username: username)

        if user && is_password?(user.password)
            user 
        else 
            nil 
        end 
    end

   
    attr_reader :password 

    
    def reset_session_token!
        self.session_token = SecureRandom::urlsafe_base64(16)
        self.save!
        self.session_token
    end


    def password=(password)
        @password = password 
        self.password_digest = BCrypt::Password.create(password) ### plain text example "starwars" return a hash string 
    end

     def is_password?(password)
        password_object = BCrypt::Password.new(self.password_digest) ### hash string and return a bcrypt object
        password_object.is_password?(password)
    end

    def ensure_session_token
        self.session_token ||= SecureRandom.urlsafe_base64(16)
    end 

end
