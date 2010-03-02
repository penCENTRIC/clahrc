class Image < Asset
  validates_attachment_content_type :data, :content_type => [ 'image/gif', 'image/jpeg', 'image/png' ], :if => Proc.new { |record| record.kind_of?(Image) }
end
