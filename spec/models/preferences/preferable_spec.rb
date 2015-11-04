require 'spec_helper'

describe Spree::Preferences::Preferable do

  before :all do
    class A
      include Spree::Preferences::Preferable
      attr_reader :id

      def initialize
        @id = rand(999)
      end

      preference :color, :string, :default => 'green', :description => "My Favorite Color"
    end

    class B < A
      preference :flavor, :string
    end
  end

  before :each do
    @a = A.new
    @a.stub(:persisted? => true)
    @b = B.new
    @b.stub(:persisted? => true)
  end

  describe "preference definitions" do
    it "parent should not see child definitions" do
      @a.has_preference?(:color).should be_true
      @a.has_preference?(:flavor).should_not be_true
    end

    it "child should have parent and own definitions" do
      @b.has_preference?(:color).should be_true
      @b.has_preference?(:flavor).should be_true
    end

  end

  describe "preference access" do
    context "database fallback" do
      before do
        @a.instance_variable_set("@pending_preferences", {})
      end

      it "retrieves a preference from the database before falling back to default" do
        preference = mock(:value => "chatreuse")
        Spree::Preference.should_receive(:find_by_name).with(:color).and_return(preference)
        @a.preferred_color.should == 'chatreuse'
      end

      it "defaults if no database key exists" do
        Spree::Preference.should_receive(:find_by_name).and_return(nil)
        @a.preferred_color.should == 'green'
      end
    end
  end
end
