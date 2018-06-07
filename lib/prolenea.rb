require 'faraday'
require 'active_support'
require 'prolenea/version'
require 'prolenea/connection'

module Prolenea

  module ClassMethods

    def connection
      @connection ? @connection : (raise StandardError)
    end

    def connect(config = {})
      @connection = Connection.new(:uri => config[:uri])
    end

  end

  extend ClassMethods

end
