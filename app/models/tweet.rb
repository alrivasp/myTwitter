class Tweet < ApplicationRecord
  belongs_to :user
  #Canitdad de like
  has_many :likes
  #Usuario que le dieron Like
  has_many :linking_users, :through => :likes, :source => :user

  validates :content, presence: true, length: { maximum: 140, too_long: "%{count} maximo de caracteres permitidos" }

  paginates_per 5

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

  #
  def is_retweet?
    rt_ref ? true : false
  end

  def tweet_ref
    Tweet.find(self.rt_ref)
  end

  def list_of_rt
    list = Tweet.where(rt_ref: self)
    return list
  end

end
