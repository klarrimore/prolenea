module Prolenea
  class ProleneaResponseMiddleware < Faraday::Response::Middleware

    PORTED_DATE_TIMEZONE = '-0500'

    PORTED_DATE_FORMAT = '%Y%m%d%H'

    RESPONSE_ROW_NAMES = %w(
      number
      local_routing_number
      ported_date
      alternative_spid
      alternative_spid_name
      line_type
      operating_company_number
      operating_company_name
      lata
      city
      state
    )

    def on_complete(env)
      case env[:status]
      when 200
        env[:parsed_body] = self.parse_body env[:body]
      else
        raise ProleneaRequestError.new({}), "Recieved an unexpected HTTP response code #{env[:status]}"
      end

      env
    end

    def parse_body(body)
      number_info = {}
      rows = body.split("\r\n")

      if rows.length != RESPONSE_ROW_NAMES.length
        raise ProleneaRequestError.new({}), "Unable to parse HTTP response body"
      end

      rows.each_with_index do |row, i|
        number_info[RESPONSE_ROW_NAMES[i]] = (row == '-' ? nil : row)
      end

      self.parse_number_info number_info
    end

    def parse_number_info(number_info)
      if number_info['ported_date']
        parsed_ported_date = self.parse_ported_date number_info['ported_date']

        number_info['ported_date'] = parsed_ported_date.iso8601
      end

      number_info
    end

    def parse_ported_date(s)
      if !s.nil? && !s.empty?
        DateTime.parse "#{s} #{PORTED_DATE_TIMEZONE}", "#{PORTED_DATE_FORMAT} %z"
      end
    end

  end
end
