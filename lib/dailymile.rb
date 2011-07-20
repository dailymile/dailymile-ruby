require 'faraday'
require 'json'
require 'oauth2'

module Dailymile
  
  VERSION = File.read(File.join(File.dirname(__FILE__), '..', 'VERSION'))
  HOST = 'api.dailymile.com'
  BASE_URI = "https://#{HOST}"
  OAUTH_AUTHORIZE_PATH = '/oauth/authorize'
  OAUTH_TOKEN_PATH = '/oauth/token'
  
  class DailymileError      < StandardError; end
  class NotFound            < DailymileError; end
  class Unauthorized        < DailymileError; end
  class Forbidden           < DailymileError; end
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

require 'dailymile/connection' # require File.expand_path(File.dirname(__FILE__) + '/dailymile/connection')
require 'dailymile/connection/token'
require 'dailymile/client'
require 'dailymile/entry'
