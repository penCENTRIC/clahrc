module ApplicationHelper
  # Site copyright notice
  def copyright_notice
    raw %Q(<p>Copyright &copy; #{copyright_period} NIHR CLAHRC for the Southwest Peninsula</p>)
  end
  
  # Period to which the site copyright notice applies
  def copyright_period
    if Time.now.year > 2009
      raw %Q(2009&ndash;#{Time.now.year})
    else
      raw %Q(2009)
    end
  end
end
