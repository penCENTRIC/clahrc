class User
  module Indexed
    def self.included(base)
      base.define_index do
        indexes profile.full_name, :as => :full_name
        indexes profile.previous_full_name, :as => :previous_full_name
        indexes profile.about, :as => :about

        #set_property :delta => true
      end
    end
  end
end