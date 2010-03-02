class Audio < Asset
  validates_attachment_content_type :data, :content_type => [ 'audio/mpeg', 'audio/mpeg3' ], :if => Proc.new { |record| record.kind_of?(Audio) }
end
