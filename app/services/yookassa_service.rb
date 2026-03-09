class YookassaService
  def initialize
    @shop_id = ENV['YOOKASSA_SHOP_ID']
    @secret_key = ENV['YOOKASSA_SECRET_KEY']
    @test_mode = ENV['YOOKASSA_TEST_MODE'] == 'true'
  end

  def create_payment(amount:, description:, metadata: {})
    uri = URI('https://api.yookassa.ru/v3/payments')
    
    # Сумма в копейках (ЮKassa принимает в рублях с копейками)
    amount_value = sprintf('%.2f', amount.to_f / 100)
    
    body = {
      amount: {
        value: amount_value,
        currency: 'RUB'
      },
      confirmation: {
        type: 'redirect',
        return_url: "#{ENV['APP_URL']}/profile"
      },
      capture: true,
      description: description,
      metadata: metadata
    }

    request = Net::HTTP::Post.new(uri)
    request.basic_auth(@shop_id, @secret_key)
    request['Content-Type'] = 'application/json'
    request['Idempotence-Key'] = SecureRandom.uuid
    request.body = body.to_json

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(request)
    end

    if response.is_a?(Net::HTTPSuccess)
      data = JSON.parse(response.body)
      {
        success: true,
        payment_id: data['id'],
        confirmation_url: data['confirmation']['confirmation_url'],
        status: data['status']
      }
    else
      Rails.logger.error "Yookassa error: #{response.body}"
      {
        success: false,
        error: response.body
      }
    end
  rescue => e
    Rails.logger.error "Yookassa exception: #{e.message}"
    { success: false, error: e.message }
  end
end