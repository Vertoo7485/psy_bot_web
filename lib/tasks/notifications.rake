namespace :notifications do
  desc "Отправка утренних push-уведомлений"
  task send_morning: :environment do
    message = "🌅 Доброе утро! Готовы к сегодняшней практике?"
    send_push_to_all(message)
  end

  desc "Отправка вечерних push-уведомлений"
  task send_evening: :environment do
    message = "🌇 Как прошёл ваш день? Не забудьте записать эмоции."
    send_push_to_all(message)
  end

  def send_push_to_all(message)
    PushSubscription.find_each do |sub|
      begin
        Webpush.payload_send(
          endpoint: sub.endpoint,
          message: message,
          p256dh: sub.p256dh,
          auth: sub.auth,
          vapid: {
            subject: "mailto:larchenkovad@bk.ru",
            public_key: ENV['VAPID_PUBLIC_KEY'],
            private_key: ENV['VAPID_PRIVATE_KEY']
          }
        )
      rescue => e
        puts "Ошибка отправки: #{e.message}"
        # Если подписка невалидна — удаляем
        sub.destroy if e.message.include?('410')
      end
    end
  end
end