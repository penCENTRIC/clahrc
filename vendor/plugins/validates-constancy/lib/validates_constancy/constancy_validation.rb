# Defines ConstancyValidation.

require 'active_record'

# When this module is included in ActiveRecord::Base, the validation method in
# ConstancyValidation::ClassMethods becomes available to all Active Record
# models.
module ConstancyValidation
  
  ActiveRecord::Errors.default_error_messages[:constancy] = "can't be changed"
  
  # The following validation is defined in the class scope of the model that
  # you're interested in validating. It offers a declarative way of specifying
  # when the model is valid and when it is not.
  module ClassMethods
    
    # Encapsulates the pattern of wanting to protect one or more model
    # attributes from being changed after the model object is created. Example:
    # 
    #   class Person < ActiveRecord::Base
    #     
    #     # Prevent changes to Person#user_name and Person#member_since.
    #     validates_constancy_of :user_name, :member_since
    #     
    #   end
    # 
    # This check is performed only on update.
    # 
    # Configuration options:
    # 
    # [<tt>:message</tt>] A custom error message (default is: "can't be changed")
    # [<tt>:if</tt>] Specifies a method, Proc or string to call to determine if the validation should occur (e.g., <tt>:if => :allow_validation</tt>, or <tt>:if => Proc.new { |user| user.signup_step > 2 }</tt>). The method, Proc or string should return or evaluate to +true+ or +false+.
    # 
    # Warning: With associations, validate the constancy of a foreign key, not
    # the instance variable itself: <tt>validates_constancy_of :invoice_id</tt>
    # instead of <tt>validates_constancy_of :invoice</tt>.
    # 
    # Also note the warning under <em>Inheritable callback queues</em> in
    # http://api.rubyonrails.org/classes/ActiveRecord/Callbacks.html. "In order
    # for inheritance to work for the callback queues, you must specify the
    # callbacks before specifying the associations. Otherwise, you might trigger
    # the loading of a child before the parent has registered the callbacks and
    # they won't be inherited." Validates Constancy uses these callback queues,
    # so you'll want to specify associations *after* +validates_constancy_of+
    # statements in your model classes.
    def validates_constancy_of(*attribute_names)
      options = {:message =>
                 ActiveRecord::Errors.default_error_messages[:constancy]}
      options.merge!(attribute_names.pop) if attribute_names.last.kind_of?(Hash)
      
      constant_names = base_class.instance_variable_get(:@constant_attribute_names) ||
                       []
      constant_names.concat attribute_names.collect!(&:to_s)
      base_class.instance_variable_set :@constant_attribute_names,
                                       constant_names
      
      ConstancyValidation::OriginalAttributesCapture.extend self
      
      options.merge! :on => :update
      validates_each(attribute_names, options) do |record, attribute_name, value|
        unless value ==
               record.instance_variable_get(:@original_attributes)[attribute_name]
          record.errors.add attribute_name, options[:message]
        end
      end
      
      self
    end
    
  end
  
  class OriginalAttributesCapture #:nodoc:
    
    class << self
      
      def extend(klass)
        return false if klass.method_defined?(:capture_original_attributes)
        
        create_method_capture_original_attributes klass
        
        create_method_after_find_unless_exists klass
        klass.after_find :capture_original_attributes
        klass.after_save :capture_original_attributes
        
        true
      end
      
    private
      
      def create_method(klass, method_name, &block)
        klass.class_eval { define_method method_name, &block }
      end
      
      def create_method_after_find_unless_exists(klass)
        # Active Record does not define Base#after_find -- it gets called
        # dynamically if present. So we need to define a do-nothing method to
        # serve as the head of the method chain.
        return false if klass.method_defined?(:after_find)
        
        create_method(klass, :after_find) { self }
        
        true
      end
      
      def create_method_capture_original_attributes(klass)
        create_method(klass, :capture_original_attributes) do
          constant_names = self.class.base_class.instance_variable_get(:@constant_attribute_names) ||
                           []
          originals = constant_names.inject({}) do |result, attribute_name|
            result[attribute_name] = read_attribute(attribute_name)
            result
          end
          instance_variable_set :@original_attributes, originals
          self
        end
      end
      
    end
    
  end
  
  def self.included(other_module) #:nodoc:
    other_module.extend ClassMethods
  end
  
end
