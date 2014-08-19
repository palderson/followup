class AddMeetingLocationToFriendships < ActiveRecord::Migration
  def change
    add_column :friendships, :meeting_location, :string
  end
end
