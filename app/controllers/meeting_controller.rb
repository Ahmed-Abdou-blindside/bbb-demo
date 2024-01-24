require 'bigbluebutton_api'

# require '../lib/bigbluebutton_helper'
require_relative '../../lib/big_blue_button_helper'

class MeetingController < ApplicationController
    include BigBlueButtonHelper
    include OmniauthHelper
    before_action :prepare
    before_action :authenticate_user!, except: %i[meeting_close], raise: false

    def create
        num = rand(1000)
        meeting_name = "BBB-Demo #{num}"
        meeting_id = "#{num}"
        moderator_name = "Ahmed Abdou"
        attendee_name = "Cameron"
    
        options = {
          moderatorPW: "54321",
          attendeePW: "12345",
          welcome: 'Welcome to my meeting',
          dialNumber: '1-800-000-0000x00000#',
          logoutURL: 'https://github.com/mconf/bigbluebutton-api-ruby',
          record: true,
          maxParticipants: 25
        }
        # getRecordings - in the doc Ahmad sent, API call.
    
        response = @api.create_meeting(meeting_name, meeting_id, options)
    
        puts "The meeting has been created with the response:"
        puts response.inspect

        @join_url = @api.join_meeting_url(meeting_id, moderator_name, options[:moderatorPW])


        @recordings = []
 
        meeting_ids = list_room_ids
      
        options = { meetingID: meeting_ids }  # Pass an options hash with :meetingID
      
        @recordings = @api.get_recordings(options)
        puts "PRINTING @RECORDINGS!!!!"
        puts @recordings

        puts "SETTING THE MEETING ID FOR THE VIEW"

        # @join_url = "https://www.google.com/"
        puts "past meeting id creation"
        puts "ATTEMPTING TO RENDER PAGE"
        respond_to do |format|
            format.html # Render the HTML view template
            format.json { render json: response } # Respond with JSON if needed
        end
        puts "RENDERED PAGE"
      
      rescue Exception => ex
        puts "Failed with error #{ex.message}"
        puts ex.backtrace
    end

    def createNewRoom
        num = rand(1000)
        meeting_name = "BBB-Demo #{num}"
        meeting_id = "#{num}"
        moderator_name = "Ahmed Abdou"
        attendee_name = "Cameron"
    
        options = {
          moderatorPW: "54321",
          attendeePW: "12345",
          welcome: 'Welcome to my meeting',
          dialNumber: '1-800-000-0000x00000#',
          logoutURL: 'https://github.com/mconf/bigbluebutton-api-ruby',
          record: true,
          maxParticipants: 25
        }

        room = Room.create(
            name: meeting_name,
            meeting_id: meeting_id,
            moderator_password: options[:moderatorPW],
            attendee_password: options[:attendeePW],
            welcome_message: options[:welcome],
            dial_number: options[:dialNumber],
            logout_url: options[:logoutURL],
            room_recording: options[:record],
            max_participants: options[:maxParticipants],
            create_meeting: @api.create_meeting(meeting_name, meeting_id, options),
            join_url: @api.join_meeting_url(meeting_id, moderator_name, options[:moderatorPW])
          )

          redirect_to bigbluebutton_join_path
    end

    def list_room_ids
        @room_ids = Room.pluck(:meeting_id)
    end


    def list_recordings
        @recordings = []
 
        meeting_ids = list_room_ids
      
        options = { meetingID: meeting_ids }  # Pass an options hash with :meetingID
      
        @recordings = @api.get_recordings(options)
        puts "PRINTING @RECORDINGS!!!!"
        puts @recordings

        
      end

      def delete_recording
        recording_id = params[:recording_id]
        @api.delete_recordings([recording_id])
        puts "Recording with ID #{recording_id} deleted successfully."
        
        redirect_to bigbluebutton_join_path
      end

      def authenticate_user!
        @launch_nonce = params['launch_nonce']
        return unless omniauth_provider?(:bbbltibroker)
        # Assume user authenticated if session [params[launch_nonce]] is set
        return if session[@launch_nonce]
    
        redirector = omniauth_authorize_path(:bbbltibroker, launch_nonce: params[:launch_nonce])
        redirect_post(redirector, options: { authenticity_token: :auto }) && return if params['action'] == 'launch'
    
        # redirect_to(errors_path(401))
      end

      def meeting_close
        respond_to do |format|
          broadcast_meeting(action: 'someone left', delay: true)
          format.html { render(:autoclose) }
        end
      end


end