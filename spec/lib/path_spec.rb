# encoding: utf-8

require 'spec_helper'

describe MenuStructure::Path do

  describe "path" do

    subject { MenuStructure::Path.new(path) }
    let(:path) { @path }

    it "should return a given string" do
      @path = "/path"
      expect(subject.path).to eq path
    end

    it "should call on a callable object" do
      @path = -> { "/path" }
      expect(subject.path).to eq "/path"
    end

  end

  describe "active?" do

    context "path plain" do

      subject { MenuStructure::Path.new("/path/controller/action") }

      it "should be active for an exact path given" do
        expect(subject).to be_active("/path/controller/action")
      end

      it "should be active for an path given with extra options" do
        expect(subject).to be_active("/path/controller/action?some=thing")
      end

      it "should not be active for another path given" do
        expect(subject).not_to be_active("/other")
      end

      it "should not be active for a part given" do
        expect(subject).not_to be_active("/path/controller")
      end

    end

    context "path given as callable object" do

      subject { MenuStructure::Path.new(-> { "/path/action" }) }

      it "should be active for an exact path given" do
        expect(subject).to be_active("/path/action")
      end

    end

  end

end
