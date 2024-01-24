require File.expand_path('../../../lib/big_blue_button_helper', __FILE__)

# frozen_string_literal: true

require 'rails_helper'

describe MeetingController, type: :controller do
  # let(:rooms) { Room.all }
  # let(:bbb_api) { BigBlueButton::BigBlueButtonApi.new('https://bbb-dev.ahmed.blindside-ps.dev/bigbluebutton/api', 'xm497Y5yv0LJUt3pk7og2jaO6HDnMEXyjJMabwEQcdk', '1.0', Rails.logger) }

  # before :each do
  #   allow_any_instance_of(MeetingController).to(receive(:authenticate_user!).and_return(:success))

  #   # bbb = initialize_bbb_api({
  #   #   'url' => 'https://bbb-dev.ahmed.blindside-ps.dev/bigbluebutton/api',
  #   #   'secret' => 'xm497Y5yv0LJUt3pk7og2jaO6HDnMEXyjJMabwEQcdk',
  #   #   'version' => '1.0'
  #   # })

  #   allow_any_instance_of(MeetingController).to(receive(:bbb).and_return(bbb_api))
  #   allow_any_instance_of(NotifyMeetingWatcherJob).to(receive(:bbb).and_return(bbb_api)) # stub actioncable processes

  #   @request.session['handler'] = {
  #     user_params: {
  #       uid: 'uid',
  #       full_name: 'Jane Doe',
  #       first_name: 'Jane',
  #       last_name: 'Doe',
  #       email: 'jane.doe@email.com',
  #       roles: 'Administrator,Instructor,Administrator',

  #     },
  #   }

  #   @user = BbbAppRooms::User.new(uid: 'uid',
  #                                 full_name: 'Jane Doe',
  #                                 first_name: 'Jane',
  #                                 last_name: 'Doe',
  #                                 email: 'jane.doe@email.com',
  #                                 roles: 'Administrator,Instructor,Administrator')

  #   # Currently a new room is created before every test. This could be optimized by creating a new room only before tests that require it.
  #   @room = create(:room)
  # end

  describe "POST #createNewRoom" do
    it "creates a new room and redirects to the join page" do
      @room = create(:room)
      
      post :createNewRoom

      expect(response).to redirect_to(bigbluebutton_join_path)
    end
  end
#   describe '#createNewRoom' do
#   it 'creates a new room with room information' do
#     expect do
#       post(:createNewRoom, params: {
#              room: {
#                name: 'rspec room',
#                description: 'description',
#                handler: :launch_params,
#                recording: true,
#                wait_moderator: false,
#                all_moderators: false,
#              },
#            })
#     end.to(change { Room.count }.by(1))
#   end
# end
# end


  describe 'recordings' do
    context 'GET #recording_update' do
      it 'gets the recordings details' do
        bbb_api_double = instance_double(BigBlueButton::BigBlueButtonApi)
        allow(bbb_api_double).to receive(:get_recordings).and_return(true)

        allow_any_instance_of(BigBlueButtonHelper).to receive(:prepare).and_return(bbb_api_double)

        allow_any_instance_of(MeetingController).to(receive(:list_recordings).and_return(true))
        # meeting_controller = MeetingController.new
        # allow(meeting_controller).to receive(:prepare).and_return(bbb_api_double)
        expect(response).to(have_http_status(200))
      end
    end
  end

  describe 'DELETE #delete_recording' do

  it 'deletes a recording and redirects to bigbluebutton_join_path' do
    @room = create(:room)
    allow_any_instance_of(MeetingController).to receive(:delete_recording).and_return(true)
    post :delete_recording, params: { recording_id: Faker::IDNumber.valid }
    expect(response).to have_http_status(204)
  end
end


end