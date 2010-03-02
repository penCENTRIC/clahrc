module RPH
  module PrettyFlash
    module ControllerMethods
      TYPES = [:notice, :warning, :error]
      
      TYPES.each do |type|
        define_method(type) do |msg|
          flash[type] = msg
        end
        
        define_method("#{type}_now") do |msg|
          flash.now[type] = msg
        end
      end
    end
  
    module Display
      def display_flash_messages
        html = flash.collect do |css_class, message|
          content_tag :p, content_tag(:span, message), :class => css_class
        end

        unless html.blank?
          content_tag(:div, html.join, :id => 'flash')
        end
      end
    end
  end
end