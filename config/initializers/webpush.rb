if Rails.env.development?
  module Webpush
    class Connection
      def send_notification
        uri = URI.parse(@endpoint)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = false  # Отключаем SSL для теста
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        
        request = Net::HTTP::Post.new(uri.request_uri, @headers)
        request.body = @payload
        http.request(request)
      end
    end
  end
end