require 'faraday'
require 'json'
require 'prolenea/version'
require 'prolenea/errors'
require 'prolenea/connection'
require 'prolenea/middleware/prolenea_response_middleware'

module Prolenea
  include Error

  module ClassMethods

    def connection
      @connection ? @connection : (raise ProleneaNoConnectionError)
    end

    def connect(config = {})
      @connection = Connection.new(:uri => config[:uri])
    end

    def connected?
      !@connection.nil?
    end

    def lookup_number(number)
      params = {:dial => number}

      response = self.connection.get '/', params

      response.env[:parsed_body]
    rescue ProleneaError => pe
      raise ProleneaLookupError.new({:parent_error => pe}), pe.message
    rescue StandardError => se
      raise ProleneaLookupError.new({:parent_error => se}), se.message
    end

  end

  extend ClassMethods

  Faraday::Response.register_middleware :prolenea_response => lambda { ProleneaResponseMiddleware }
end
