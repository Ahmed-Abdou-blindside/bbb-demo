require 'bigbluebutton_api'
require 'yaml'

module BigBlueButtonHelper
  def prepare
      config_file = File.join(Rails.root, 'config', 'config.yml')
      unless File.exist?(config_file)
        puts "UNLESS FILE.EXISTS START"
        puts "#{config_file} does not exist. Create the file and configure your server."
        puts "Example config.yml content:"
        puts <<~YAML
          servers:
            default:
              url: https://bbb-dev.ahmed.blindside-ps.dev/bigbluebutton/
              secret: xm497Y5yv0LJUt3pk7og2jaO6HDnMEXyjJMabwEQcdk
              version: 2.7.4
        YAML
        puts
        puts "UNLESS FILE.EXISTS ENDS"
        puts
        Kernel.exit!
      end

      @config = YAML.load_file(config_file)

      puts "** Config:"
      @config.each do |k,v|
        puts k + ": " + v.to_s
      end
      puts
    

      key = @config['servers'].keys.first
      server = @config['servers'][key]
      
      server = @config['servers']['default'] # Use the 'default' server configuration
      puts "YAML LOAD FILE START"
      puts "** Using the server:"
      puts server.inspect

      puts
      @api = BigBlueButton::BigBlueButtonApi.new(server['url'], server['secret'], server['version'].to_s)

    end

    def initialize_bbb_api(server_config)
      bbb_url = remove_slash(server_config['url'])
      bbb_secret = server_config['secret']
      bbb_version = server_config['version'].to_s
      BigBlueButton::BigBlueButtonApi.new(bbb_url, bbb_secret, bbb_version, Rails.logger)
    end
  end