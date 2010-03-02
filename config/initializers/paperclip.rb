Paperclip.options[:command_path] = case RAILS_ENV.to_sym
when :production
  %{/usr/bin}
else
  %{/opt/local/bin}
end