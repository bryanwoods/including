require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Object" do
  before do
    module Foo
      def foo; "foo"; end
      def bar; "bar"; end
      def baz; "baz"; end
    end

    class Bar; end
  end

  describe "#including" do
    context "provided no options arguments" do
      context "provided a valid module" do
        before do
          Bar.class_eval do
            including Foo
          end
        end

        it "mixes in the provided module" do
          bar = Bar.new

          bar.foo.should == "foo"
          bar.bar.should == "bar"
          bar.baz.should == "baz"
        end
      end

      context "provided an invalid module" do
        it "raises an exception" do
          expect do
            Bar.class_eval { including NotAModule }
          end.to raise_error(NameError)
        end
      end
    end
  end

  context "provided an 'only' options argument" do
    before do
      Bar.class_eval { including Foo, only: [:foo, :bar] }
    end

    it "undefines all methods listed in the 'only' array" do
      bar = Bar.new

      bar.foo.should == "foo"
      bar.bar.should == "bar"

      expect { bar.baz }.to raise_error(NoMethodError)
    end
  end

  context "provided an 'except' options argumenmt" do
    before do
      Bar.class_eval { including Foo, except: [:foo] }
    end

    it "undefines all methods not listed in the 'except' array" do
      bar = Bar.new

      expect { bar.foo }.to raise_error(NoMethodError)

      bar.bar.should == "bar"
      bar.baz.should == "baz"
    end
  end
end
