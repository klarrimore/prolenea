module Prolenea
  class Connection

    USER_AGENT = "prolenea-client v#{Prolenea::VERSION}"

    attr_accessor :options, :faraday

    def initialize(options = {})
      uri = options.delete :uri
      @options = options
      @faraday = self.create_faraday(uri, @options)
    end

    def create_faraday(uri, options = {})
      @faraday = Faraday.new uri, options do |c|
        c.headers['User-Agent'] = USER_AGENT

        c.request :multipart
        c.request :url_encoded        

        c.response :prolenea_response

        c.adapter Faraday.default_adapter
      end
    end

    def request(method, path, params, options, &callback)
      sent_at = nil

      response = @faraday.send(method) { |request|
        sent_at = Time.now
        request = config_request(request, method, path, params, options)
      }.on_complete { |env|
        env[:total_time] = Time.now.utc.to_f - sent_at.utc.to_f if sent_at
        env[:request_params] = params
        env[:request_options] = options
        callback.call(env) if callback
      }

      response
    end

    def config_request(request, method, path, params, options)
      case method.to_sym
      when :delete, :get
        request.url(path, params)
      when :post, :put
        request.path = path
        request.body = params unless params.empty?
      end

      request
    end

    def get(path, params={}, options={}, &callback)
      request(:get, path, params, options, &callback)
    end

    def delete(path, params={}, options={}, &callback)
      request(:delete, path, params, options, &callback)
    end

    def post(path, params={}, options={}, &callback)
      request(:post, path, params, options, &callback)
    end

    def put(path, params={}, options={}, &callback)
      request(:put, path, params, options, &callback)
    end

  end
end
