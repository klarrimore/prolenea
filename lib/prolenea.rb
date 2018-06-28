require 'faraday'
require 'json'
require 'date'
require 'prolenea/version'
require 'prolenea/errors'
require 'prolenea/connection'
require 'prolenea/middleware/prolenea_response_middleware'

module Prolenea
  include Error

  DEFAULT_TIMEOUT = 10

  module ClassMethods

    attr_accessor :default_timeout

    def connection
      @connection ? @connection : (raise ProleneaNoConnectionError.new({}), 'Connection is not setup')
    end

    def connect(config = {})
      @default_timeout = config[:default_timeout] || DEFAULT_TIMEOUT
      @connection = Connection.new(:uri => config[:uri])
    end

    def connected?
      !@connection.nil?
    end

    def lookup_number(number, options = {})
      params = {:dial => number}

      response = self.connection.get '/', params, options

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
