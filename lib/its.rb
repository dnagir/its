require "its/version"
require "rspec/core"

module Its
  module ExampleGroupMethods

    # Creates a nested example group named by the submitted +attribute+,
    # and then generates an example using the submitted block.
    #
    #   # This ...
    #   describe Array do
    #     its(:size) { should eq(0) }
    #   end
    #
    #   # ... generates the same runtime structure as this:
    #   describe Array do
    #     describe "size" do
    #       it "should eq(0)" do
    #         subject.size.should eq(0)
    #       end
    #     end
    #   end
    #
    # The attribute can be a +Symbol+ or a +String+. Given a +String+
    # with dots, the result is as though you concatenated that +String+
    # onto the subject in an expression.
    #
    #   describe Person do
    #     subject do
    #       Person.new.tap do |person|
    #         person.phone_numbers << "555-1212"
    #       end
    #     end
    #
    #     its("phone_numbers.first") { should eq("555-1212") }
    #   end
    #
    # When the subject is a +Hash+, you can refer to the Hash keys by
    # specifying a +Symbol+ or +String+ in an array.
    #
    #   describe "a configuration Hash" do
    #     subject do
    #       { :max_users => 3,
    #         'admin' => :all_permissions }
    #     end
    #
    #     its([:max_users]) { should eq(3) }
    #     its(['admin']) { should eq(:all_permissions) }
    #
    #     # You can still access to its regular methods this way:
    #     its(:keys) { should include(:max_users) }
    #     its(:count) { should eq(2) }
    #   end
    #
    # You can also pass any additional arguments the target method can accept:
    #
    #   describe Person do
    #     subject do
    #       Person.new.tap do |person|
    #         person.phone_numbers << "123-123"
    #         person.phone_numbers << "234-234"
    #         person.phone_numbers << "xxx-xxx"
    #       end
    #     end
    #
    #     its("phone_numbers.first", 2) { should == ["123-123", "234-234"]
    #   end
    #
    #
    # This is extraction for the RSpec Core.
    # For reference, see:
    # - https://github.com/rspec/rspec-core/blob/7ce078e4948e8f0d1745a50bb83dd87a68b2e50e/lib/rspec/core/subject.rb#L120
    # This modifies the following behaviour:
    # - calls the target with arguments passed it
    # - changes the description to include the args (if any)
    def its(attribute, *args, &block)
      desc = attribute.to_s
      desc += "(#{args.map{|a| a.nil? ? 'nil' : a.to_s}.join(', ')})" unless args.empty?

      describe(desc) do
        example do
          self.class.class_eval do
            define_method(:subject) do
              @_subject ||= if attribute.is_a?(Array)
                              super()[*attribute]
                            else
                              attribute.to_s.split('.').inject(super()) do |target, method|
                                target.send(method, *args)
                              end
                            end
            end
          end
          instance_eval(&block)
        end
      end
    end

  end

end

RSpec::Core::ExampleGroup.send :extend, Its::ExampleGroupMethods
