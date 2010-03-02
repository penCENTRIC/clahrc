module Versionable
  def self.included(base)
    base.versioned
  end
end