class AddRestaurantIdToUser < ActiveRecord::Migration
  def change
    add_reference :users, :user, index: true
    add_foreign_key :users, :users
  end
end
