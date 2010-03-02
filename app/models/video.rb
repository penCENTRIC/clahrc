class Video < Asset
  validates_attachment_content_type :data, :content_type => [ 'video/mpeg' ], :if => Proc.new { |record| record.kind_of?(Video) }
end
