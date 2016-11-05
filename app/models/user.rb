class User < ApplicationRecord
  devise 	:database_authenticatable, :registerable, 
  				:validatable, :confirmable, :omniauthable

  def self.find_for_oauth(auth)
  	email = auth.info.email || "email@#{auth.uid}-#{auth.provider}.com"
  	user = User.find_by(email: email)
    if user.nil?
      user = User.new(
        name: auth.info.name,
        email: email,
        password: Devise.friendly_token[0,20]
      )
      user.skip_confirmation!
      user.save!
    end
    user
  end
end
