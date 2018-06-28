module Prolenea
  module Error
    class ProleneaError < StandardError #:nodoc:
      attr_accessor :options

      def initialize(message, options = {})
        @options = options
        super message
      end
    end

    class ProleneaRequestError < ProleneaError #:nodoc:
    end

    class ProleneaLookupError < ProleneaError #:nodoc:
    end

    class ProleneaNoConnectionError < ProleneaError #:nodoc:
    end
  end
end
