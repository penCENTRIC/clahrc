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
  
  def searchify(s)
    s = s.to_s.mb_chars.normalize(:kd)

    s.gsub!(/[^\w -]+/n, '')  # strip unwanted characters
    s.strip!
    s.downcase!
    s.gsub!(/[ -]+/, ' ')
  
    s
  end    
end
