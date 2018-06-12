module Prolenea
  class ProleneaResponseMiddleware < Faraday::Response::Middleware

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
        raise StandardError, "recieved an unexpected HTTP response code #{env[:status]}"
      end

      env
    end

    def parse_body(body)
      number_info = {}
      rows = body.split("\r\n")

      rows.each_with_index do |row, i|
        number_info[RESPONSE_ROW_NAMES[i]] = (row == '-' ? nil : row)
      end

      number_info
    end

  end
end
