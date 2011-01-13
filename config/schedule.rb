env :MAILTO, 'mhg@taose.co.uk'

every 1.minute do
  rake "clahrc:notify"
end

every 1.hour do
  rake "thinking_sphinx:index"
end

every 1.day, :at => '4:45 pm' do
  rake "clahrc:deliver_digest_email"
end
