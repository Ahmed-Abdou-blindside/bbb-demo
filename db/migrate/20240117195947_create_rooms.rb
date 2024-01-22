class CreateRooms < ActiveRecord::Migration[7.1]
  def change
    create_table :rooms do |t|
      t.string :name
      t.string :meeting_id
      t.string :moderator_password
      t.string :attendee_password
      t.string :welcome_message
      t.string :dial_number
      t.string :logout_url
      t.boolean :room_recording
      t.integer :max_participants
      t.string :create_meeting
      t.string :join_url

      t.timestamps
    end
  end
end
