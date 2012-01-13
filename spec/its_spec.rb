require 'its'

describe "#its" do
  subject do
    Class.new do
      def initialize
        @call_count = 0
      end

      def call_count
        @call_count += 1
      end
    end.new
  end

  context "with a call counter" do
    its(:call_count) { should eq(1) }
  end

  context "with nil value" do
    subject do
      Class.new do
        def nil_value
          nil
        end
      end.new
    end
    its(:nil_value) { should be_nil }
  end

  context "with nested attributes" do
    subject do
      Class.new do
        def name
          "John"
        end
      end.new
    end
    its("name")            { should eq("John") }
    its("name.size")       { should eq(4) }
    its("name.size.class") { should eq(Fixnum) }
  end

  context "when it responds to #[]" do
    subject do
      Class.new do
        def [](*objects)
          objects.map do |object|
            "#{object.class}: #{object.to_s}"
          end.join("; ")
        end

        def name
          "George"
        end
      end.new
    end
    its([:a]) { should eq("Symbol: a") }
    its(['a']) { should eq("String: a") }
    its([:b, 'c', 4]) { should eq("Symbol: b; String: c; Fixnum: 4") }
    its(:name) { should eq("George") }
    context "when referring to an attribute without the proper array syntax" do
      context "it raises an error" do
        its(:age) do
          expect do
            should eq(64)
          end.to raise_error(NoMethodError)
        end
      end
    end
  end

  context "when it does not respond to #[]" do
    subject { Object.new }

    context "it raises an error" do
      its([:a]) do
        expect do
          should eq("Symbol: a")
        end.to raise_error(NoMethodError)
      end
    end
  end

  context "with arguments passed in" do
    subject do
      Class.new do
        def currency(code)
          "$#{code}"
        end
      end.new
    end
    its(:currency, :us) { should eq("$us") }
    its(:currency, :uk) { should eq("$uk") }
    its(:currency, :ua) { should eq("$ua") }
  end
end
