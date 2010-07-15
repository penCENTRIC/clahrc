every 1.minute do
  rake "clahrc:notify"
end

every 1.hour do
  rake "thinking_sphinx:index"
end
