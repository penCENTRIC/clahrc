module RedCloth
  module Extensions
    def youtube(opts)
      label, url = opts[:text].split('|').map! { |str| str.strip }

      if matchdata = /\?v=([\w-]+)/.match(url)
        vid = matchdata[1]
      end

      if vid.nil?
        html = %{<div class="video"><p class="error">Bad or missing URL</p><p class="label"><a href="#{url}">#{label}</a></p></div>}
      else
        html = %{<div class="video"><object width="460" height="280"><param name="movie" value="http://www.youtube.com/v/#{vid}&hl=en&fs=1&"></param><param name="allowFullScreen" value="true"></param><param name="allowscriptaccess" value="always"></param><embed src="http://www.youtube.com/v/#{vid}&hl=en&fs=1&" type="application/x-shockwave-flash" allowscriptaccess="always" allowfullscreen="true" width="460" height="280"></embed></object><p class="label"><a href="#{url}">#{label}</a></p></div>}
      end
    end
  end
end