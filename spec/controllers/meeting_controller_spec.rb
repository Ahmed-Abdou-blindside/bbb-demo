require 'rails_helper'
require File.expand_path('../../../lib/big_blue_button_helper', __FILE__)

RSpec.describe MeetingController, type: :controller do
  describe "POST #createNewRoom" do
    it "creates a new room and redirects to the join page" do
      @room = create(:room)
      
      post :createNewRoom

      expect(response).to redirect_to(bigbluebutton_join_path)
    end
  end
end