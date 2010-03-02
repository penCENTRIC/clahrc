module BreadcrumbsHelper
  def breadcrumbs
    returning(html = "") do 
      if @breadcrumbs
        html << %Q(<p class='breadcrumbs'>)
      
        @breadcrumbs[0..-2].each do |title, path|
          html << link_to(truncate(strip_tags(title)), path)
          html << %Q(&nbsp;&raquo;&nbsp;)
        end

        html << sanitize(@breadcrumbs.last.first)
        html << %Q(</p>)
      end
    end
  end
end