require 'oauth2'
require 'json'

require 'dailymile/token'
require 'dailymile/client'

module Dailymile
  
  VERSION = File.read(File.join(File.dirname(__FILE__), '..', 'VERSION'))
  BASE_URI = 'http://localhost:3000' # 'https://api.dailymile.com'
  OAUTH_AUTHORIZE_PATH = '/oauth/authorize'
  OAUTH_TOKEN_PATH = '/oauth/token'
  
  # TODO: need error for not using https?
  class DailymileError < StandardError; end
  class NotFound            < DailymileError; end
  class Unauthorized        < DailymileError; end
  class RateLimitExceeded   < DailymileError; end
  class Unavailable         < DailymileError; end
  class UnprocessableEntity < DailymileError
    attr_reader :errors
    
    def initialize(errors)
      @errors = errors
      super
    end
  end
  
end

# 
# HACK: monkey-patching oauth2 lib
# 
module OAuth2
  class AccessToken
    def request(verb, path, params = {}, headers = {})
      @client.request(verb, path, params.merge('oauth_token' => @token))
    end
  end
  class Client
    def request(verb, url, params = {}, headers = {})
      if verb == :get
        connection.run_request(verb, url, nil, headers) do |req|
          req.params.update(params)
        end
      else
        connection.run_request(verb, url, params, headers)
      end
    end
  end
end