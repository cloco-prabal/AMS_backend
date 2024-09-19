class AddArtistIdToUsers < ActiveRecord::Migration[7.2]
  def change
    add_reference :users, :artist, null: true, foreign_key: true
  end
end
