class Friend < ApplicationRecord
  before_destroy :destroy_seguidor, prepend: true
  belongs_to :user

  def destroy_seguidor
    var = Friend.where(friend_id: self.user_id)
    var.delete_all
  end


end
