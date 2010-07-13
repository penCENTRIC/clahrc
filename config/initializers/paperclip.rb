Paperclip.options[:command_path] = case Rails.env.to_sym
when :production
  %{/usr/bin}
else
  %{/opt/local/bin}
end