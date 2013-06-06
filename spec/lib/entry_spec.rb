require 'spec_helper'

describe MenuStructure::Entry do

  before :each do
    MenuStructure.configure do |config|
      config.internal_path_splitter = ->(path) { {controller: "controller", action: "Action"} }
    end
  end

  describe "initialize" do

    subject { MenuStructure::Entry.new(parent, path, name, options) }
    let(:parent) { "parent" }
    let(:path) { "/tools/seo_research/organic_rankings" }
    let(:name) { "name" }
    let(:options) { {options: true} }

    it "should take the parent" do
      expect(subject.parent).to eq parent
    end

    it "should take the name" do
      expect(subject.name).to eq name
    end

    it "should take the options" do
      expect(subject.options).to eq options
    end

    it "should have blank children" do
      expect(subject.children).to eq []
    end

    it "should take a block and pass the children" do
      entry = MenuStructure::Entry.new(:idc, "/tools/seo_research/organic_rankings", :idc, options) { add("/tools/seo_research/svr", "child name") }
      expect(entry.children.map(&:name)).to eq ["child name"]
    end

  end

  describe "path" do

    subject { MenuStructure::Entry.new(:idc, path, :idc) }
    let(:path) { @path }

    it "should return the path string" do
      @path = "/tools/seo_research/organic_rankings"
      expect(subject.path).to eq path
    end

    it "should call the path if callable" do
      @path = -> { "My path" }
      expect(subject.path).to eq "My path"
    end

  end

  describe "active?" do

    subject { MenuStructure::Entry.new(:idc, "/tools/seo_research/domain", :icd) { add('/tools/seo_research/svr', :idc) } }

    it "should be active the given path is an active_path" do
      expect(subject).to be_active("/tools/seo_research/domain")
    end

    it "should be active the given path if the child is active" do
      expect(subject).to be_active("/tools/seo_research/svr")
    end

    it "should not be active if not the own path and not of a child" do
      expect(subject).not_to be_active("/tools/seo_research/other")
    end

  end

  describe "active_path?" do

    subject { MenuStructure::Entry.new(:idc, "/tools/overview/dashboard", :idc) }

    it "should delegate the method to path_object" do
      path_check_value = "/my/path"
      path_object = double("MenuStructure::Path")
      subject.stub(:path_object).and_return(path_object)
      path_object.should_receive(:active?).with(path_check_value).and_return(:result)
      expect(subject.active_path?(path_check_value)).to eq :result
    end

  end

  describe "path_controller" do

    subject { MenuStructure::Entry.new(:idc, "/tools/overview/dashboard", :idc) }

    it "should delegate the method to path_object" do
      path_object = double("MenuStructure::Path")
      subject.stub(:path_object).and_return(path_object)
      path_object.should_receive(:controller).and_return(:result)
      expect(subject.path_controller).to eq :result
    end

  end

  describe "path_action" do

    subject { MenuStructure::Entry.new(:idc, "/tools/overview/dashboard", :idc) }

    it "should delegate the method to path_object" do
      path_object = double("MenuStructure::Path")
      subject.stub(:path_object).and_return(path_object)
      path_object.should_receive(:action).and_return(:result)
      expect(subject.path_action).to eq :result
    end

  end

  describe "actife_leaf" do

    context "with children" do

      subject do
        MenuStructure::Entry.new(nil, '/tools/seo_research/domain', "menu.seo_research.name", title: "menu.seo_research.title", :wide_text => true) do
          add '/tools/seo_research/domain', 'menu.seo_domain.name', title: 'menu.seo_domain.title'
          add '/tools/seo_research/svr', 'menu.svr.name', title: 'menu.svr.title' do
            add '/tools/seo_research/organic_rankings', "Third level child"
          end
        end
      end

      it "should return the active child with the matching path" do
        expect(subject.active_leaf('/tools/seo_research/svr')).to eq subject.children.last
      end

      it "should return the third level child" do
        expect(subject.active_leaf('/tools/seo_research/organic_rankings').name).to eq "Third level child"
      end

      it "should return the child if the path is the same like the parent" do
        expect(subject.active_leaf('/tools/seo_research/domain')).to eq subject.children.first
      end

      it "should return nil if not matching" do
        expect(subject.active_leaf('/other')).to be_nil
      end

    end

    context "no children" do

      subject { MenuStructure::Entry.new(nil, '/tools/seo_research/domain', "menu.seo_research.name", title: "menu.seo_research.title", :wide_text => true) }

      it "should return the entry itself with the matching path" do
        expect(subject.active_leaf('/tools/seo_research/domain')).to eq subject
      end

      it "should return the nil with the not matching path" do
        expect(subject.active_leaf('/other')).to be_nil
      end

    end

  end

  describe "level" do

    let(:root) { MenuStructure::Entry.new(nil, '/tools/seo_research/organic_rankings', "First") }
    let(:child) { root.add('/tools/seo_research/svr', "Second") }
    let(:child_child) { child.add('/tools/seo_research/domain', "Third") }

    it { expect(root.level).to eq 1 }
    it { expect(child.level).to eq 2 }
    it { expect(child_child.level).to eq 3 }

  end

end
