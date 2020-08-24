class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :tweets
  #like del usuario
  has_many :likes
  #Twitter que les di Like (una especie join)
  has_many :liked_tweets, :through => :likes, :source => :tweet

end
