require 'oauth2'
require 'json'

require 'oauth2_monkey_patches'
require 'dailymile/token'
require 'dailymile/client'

module Dailymile
  
  VERSION = File.read(File.join(File.dirname(__FILE__), '..', 'VERSION'))
  BASE_URI = 'http://localhost:3000' # 'https://api.dailymile.com'
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