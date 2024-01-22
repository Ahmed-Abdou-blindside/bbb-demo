
FactoryBot.define do
    factory :room do
      name { "Sample Room" }
      meeting_id { "12345" }
      moderator_password { "54321" }
      attendee_password { "12345" }
      welcome_message { "Welcome to the room" }
      dial_number { "1-800-000-0000x00000#" }
      logout_url { "https://github.com/mconf/bigbluebutton-api-ruby" }
      room_recording { true }
      max_participants { 25 }
      create_meeting { "meeting_creation_response_here" }
      join_url { "meeting_join_url_here" }
    end
  end