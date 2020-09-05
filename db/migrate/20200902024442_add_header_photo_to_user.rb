class AddHeaderPhotoToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :header_photo, :string
  end
end
