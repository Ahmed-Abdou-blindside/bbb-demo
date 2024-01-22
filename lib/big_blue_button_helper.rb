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
    
      if ARGV.size > 0
        unless @config['servers'].has_key?(ARGV[0])
          throw Exception.new("Server #{ARGV[0]} does not exists in your configuration file.")
        end
        server = @config['servers'][ARGV[0]]
      else
        key = @config['servers'].keys.first
        server = @config['servers'][key]
      end
      server = @config['servers']['default'] # Use the 'default' server configuration
      puts "YAML LOAD FILE START"
      puts "** Using the server:"
      puts server.inspect

      puts
      @api = BigBlueButton::BigBlueButtonApi.new(server['url'], server['secret'], server['version'].to_s)

    end
  end