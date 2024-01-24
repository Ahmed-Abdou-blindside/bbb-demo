require File.expand_path('../../../lib/big_blue_button_helper', __FILE__)

# frozen_string_literal: true

require 'rails_helper'

describe MeetingController, type: :controller do


  describe "POST #createNewRoom" do
    it "creates a new room and redirects to the join page" do
      @room = create(:room)
      
      post :createNewRoom

      expect(response).to redirect_to(bigbluebutton_join_path)
    end
  end

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