every :day, at: '9:00 am' do
  rake "notifications:send_morning"
end

every :day, at: '8:00 pm' do
  rake "notifications:send_evening"
end