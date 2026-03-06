namespace :webpush do
  desc "Generate VAPID keys for web push"
  task generate_keys: :environment do
    require 'webpush'
    
    vapid_key = Webpush.generate_key
    puts "VAPID public key:  #{vapid_key.public_key}"
    puts "VAPID private key: #{vapid_key.private_key}"
    
    puts "\nДобавьте в .env:"
    puts "VAPID_PUBLIC_KEY=#{vapid_key.public_key}"
    puts "VAPID_PRIVATE_KEY=#{vapid_key.private_key}"
  end
end