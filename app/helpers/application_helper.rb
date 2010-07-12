module ApplicationHelper
  # Site copyright notice
  def copyright_notice
    %Q(<p>Copyright &copy; #{copyright_period} NIHR CLAHRC for the Southwest Peninsula</p>)
  end
  
  # Period to which the site copyright notice applies
  def copyright_period
    if Time.now.year > 2009
      %Q(2009&ndash;#{Time.now.year})
    else
      %Q(2009)
    end
  end
end
