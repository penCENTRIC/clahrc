module SubdomainRoutes
  module TestUnitMatcher
    class Base
      class TestCase < ActionController::TestCase
      end
    
      def initialize(count_method, messages, spec)
        @count_method, @messages, @spec = count_method, messages, spec
      end
      
      def run_test(target)
        result = Test::Unit::TestResult.new
        spec = @spec        
        TestCase.send :define_method, :test do
          copy_instance_variables_from(spec)
          instance_eval(&target)
        end
        TestCase.new(:test).run(result) {}
        result
      end
      
      def matches?(target)
        @result = run_test(target)
        @result_count = @result.send(@count_method)
        @result_count > 0
      end
      
      def failure_message
        "Expected #{@count_method.to_s.humanize.downcase} to be more than zero, got zero.\n"
      end

      def negative_failure_message
        "Expected #{@count_method.to_s.humanize.downcase} to be zero, got #{@result_count}:\n" +
        @result.instance_variable_get(@messages).map(&:inspect).join("\n")
      end
    end
            
    def have_errors
      Base.new(:error_count, :@errors, self)
    end
    
    def fail
      Base.new(:failure_count, :@failures, self)
    end
  end
end
