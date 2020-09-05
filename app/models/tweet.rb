class Tweet < ApplicationRecord
  include ActionView::Helpers::UrlHelper
  before_destroy :delete_tweet
  before_save :add_hashtags

  belongs_to :user
  #Canitdad de like
  has_many :likes, dependent: :destroy
  #Usuario que le dieron Like
  has_many :linking_users, :through => :likes, :source => :user

  validates :content, presence: true, length: { maximum: 140, too_long: "%{count} maximo de caracteres permitidos" }

  paginates_per 50

  scope :tweets_for_me, -> (user) { where(user_id: user.friends.pluck(:friend_id).push(user.id)) }

  def delete_tweet
    Tweet.where(rt_ref: self.id)
    Tweet.where(user_id: self.user_id).update_all(rt_ref: nil)
  end

  #metodo para agregar hashtag
  def add_hashtags
    new_array = []
    self.content.split(" ").each do |word|
      if word.start_with?("#") # #latam
        word_parsed = word.sub '#','%23'
        word = link_to( word, Rails.application.routes.url_helpers.root_path + "?search="+word_parsed )
      end
      new_array.push(word)
    end

    self.content = new_array.join(" ")
  end

  #metodo para saber si user le hizo like a un twitter
  def is_liked?(user)
    if self.linking_users.include?(user)#include lo busco dentro del hash
      true
    else
      false
    end
  end

  #Metodo para saber si esta re tweeteado
  def is_rt?(user, rt)
    if Tweet.where(user_id: user, rt_ref: rt).count == 0
      true
    else
      false
    end
  end

  #Eliminar Like
  def remove_like(user)
    Like.where(user: user, tweet:self).first.destroy
  end

  #Agregar Like
  def add_like(user)
    Like.create(user: user, tweet:self)
  end

  #Contar  Retweet
  def count_rt
    Tweet.where(rt_ref: self.id).count
  end

  #consulta si fue retweteado
  def is_retweet?
    rt_ref ? true : false
  end

  #Devuelve las referencias de retweets
  def tweet_ref
    Tweet.find(self.rt_ref)
  end

  #Devuelve lista de retweet
  def list_of_rt
    list = Tweet.where(rt_ref: self)
    return list
  end

end
