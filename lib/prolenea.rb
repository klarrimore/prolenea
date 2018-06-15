require 'faraday'
require 'json'
require 'active_support'
require 'prolenea/version'
require 'prolenea/connection'
require 'prolenea/middleware/prolenea_response_middleware'

module Prolenea

  module ClassMethods

    def connection
      @connection ? @connection : (raise StandardError)
    end

    def connect(config = {})
      @connection = Connection.new(:uri => config[:uri])
    end

    def lookup_number(number)
      params = {:dial => number}

      response = self.connection.get '/', params

      response.env[:parsed_body]
    end

  end

  extend ClassMethods

  Faraday::Response.register_middleware :prolenea_response => lambda { ProleneaResponseMiddleware }
end
