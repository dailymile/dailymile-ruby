require 'forwardable'

module Dailymile
  
  STREAM_FILTERS = %w(nearby popular)
  
  class Client
    extend Forwardable
    
    def_instance_delegators :@connection, :get, :post, :put, :delete
    
    def initialize(token = nil)
      @connection = Connection::Token.new(self.class.oauth_client, token)
    end
    
    def self.get(*args); connection.get(*args) end
    
    def self.set_client_credentials(client_id, client_secret)
      @@oauth_client = OAuth2::Client.new(client_id, client_secret,
        :site => BASE_URI,
        :access_token_path => OAUTH_TOKEN_PATH,
        :authorize_path => OAUTH_AUTHORIZE_PATH
      )
    end
    
    def self.oauth_client
      raise "Please call set_client_credentials first" if @@oauth_client.nil?
      
      @@oauth_client
    end
    
    # EXAMPLES:
    #   everyone stream: client.entries
    #   nearby stream: client.entries :nearby, 37.77916, -122.420049, :page => 2
    #   ben's stream: client.entries 'ben', :page => 2
    def self.entries(*args)
      params = extract_options_from_args!(args)
      filter = args.shift
    
      entries_path = case filter
      when String, Symbol
        filter = filter.to_s.strip
        
        if STREAM_FILTERS.include?(filter)
          if filter == 'nearby'
            lat, lon = args
            "/entries/nearby/#{lat},#{lon}"
          else
            "/entries/#{filter}"
          end
        else
          "/people/#{filter}/entries"
        end
      else
        '/entries'
      end
    
      data = get entries_path, params
      data["entries"]
    end
    
    
  private
    
    def self.extract_options_from_args!(args)
      args.last.is_a?(Hash) ? args.pop : {}
    end
    
    def self.connection
      @@connection ||= Connection.new
    end
    
  end
  
end