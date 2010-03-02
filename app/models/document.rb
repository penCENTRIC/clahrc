class Document < Asset
  validates_attachment_content_type :data, :content_type => [
    # Plain Text
    'text/plain',
    
    # Adobe PDF
    'application/pdf',
    
    # Microsoft Word
    'application/msword',
    
    # Microsoft Excel
    'application/excel',
    'application/vnd.ms-excel',
    'application/x-excel',
    'application/x-msexcel',

    # Microsoft PowerPoint
    'application/powerpoint',
    'application/vnd.ms-powerpoint',
    'application/x-powerpoint',
    'application/x-mspowerpoint',
    
    # Microsoft Project
    'application/vnd.ms-project',
    'application/x-project'
  ], :if => Proc.new { |record| record.kind_of?(Document) }
  
  def css_class
    @css_class = case self.data_file_type
    when 'text/plain'
      'text'
    when 'application/pdf'
      'pdf'
    when 'application/msword'
      'msword'
    when 'application/excel', 'application/vnd.ms-excel', 'application/x-excel', 'application/x-msexcel'
      'msexcel'
    when 'application/powerpoint', 'application/vnd.ms-powerpoint', 'application/x-powerpoint', 'application/x-mspowerpoint'
      'mspowerpoint'
    when 'application/vnd.ms-project', 'application/x-project'
      'msproject'
    else
      'file'
    end
  end
end
