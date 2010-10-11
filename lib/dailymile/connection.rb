module Dailymile
  
  class Connection
    
    DEFAULT_FORMAT = :json
    DEFAULT_HEADERS = {
      'Accept' =>  'application/json',
      'User-Agent' => "dailymile-ruby/#{VERSION}"
    }
    
    def get(path, params = {})
      request :get, path, params
    end
    
    def post(path, params = {})
      request :post, path, params
    end
    
    def put(path, params = {})
      request :put, path, params
    end
    
    def delete(path)
      request :delete, path
    end
    
  protected
  
    def make_request(verb, path, params = {}, headers = {}, &block)
      path << ".#{DEFAULT_FORMAT}" unless path =~ /.+\.\w+$/
      path << to_query_string(params) unless params.empty?
      
      response = block.call verb, path, {}, DEFAULT_HEADERS.merge(headers)
      
      handle_response(response)
    end
    
  private
  
    def request(verb, path, params = {}, headers = {})
      @connection ||= Faraday::Connection.new(:url => "http://api.dailymile.com", :headers => DEFAULT_HEADERS) do |builder|
        builder.adapter Faraday.default_adapter
        #builder.use Faraday::Response::Mashify
      end
      
      make_request(verb, path, params, headers) do |verb, path, params, headers|
        if verb == :get
          @connection.run_request(verb, path, nil, headers) do |req|
            req.params.update(params)
          end
        else
          @connection.run_request(verb, path, params, headers)
        end
      end
    end
  
    def handle_response(response)
      case response.status
      when 200, 201
        JSON.parse(response.body) rescue nil
      when 404
        raise NotFound
      when 401
        raise Unauthorized
      when 403
        raise Forbidden, "Not using HTTP over TLS"
      when 503, 502
        if response.status == 503 && response['Retry-After']
          raise RateLimitExceeded
        else
          raise Unavailable, "#{response.status}: #{response.body}"
        end
      when 422
        errors = JSON.parse(response.body) rescue nil
        raise UnprocessableEntity, errors
      else
        raise DailymileError,"#{response.status}: #{response.body}"
      end
    end
    
    def to_query_string(params = {})
      '?' + params.map do |k, v|
        if v.instance_of?(Hash)
          v.map do |sk, sv|
            ["#{k}[#{sk}]", URI.escape(sv.to_s)].join('=')
          end.join('&')
        else
          [k.to_s, URI.escape(v.to_s)].join('=')
        end
      end.join('&')
    end
    
  end
  
end