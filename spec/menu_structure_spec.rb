# encoding: utf-8

require 'spec_helper'

describe MenuStructure do

  before :each do
    MenuStructure.configure do |config|
      config.internal_path_splitter = ->(path) { {controller: "controller", action: "action"} }
    end
  end

  describe ".entries" do

    before :each do
      @old_entries = MenuStructure.entries
      MenuStructure.entries = []
    end

    after :each do
      MenuStructure.entries = @old_menu_entries
    end

    it { expect(MenuStructure.entries).to eq [] }

  end

  describe ".add" do

    before :each do
      @old_entries = MenuStructure.entries
      MenuStructure.entries = []
    end

    after :each do
      MenuStructure.entries = @old_entries
    end

    it "should return an entry" do
      expect(MenuStructure.add("path/", "Entry")).to be_a MenuStructure::Entry
    end

    it "should add one entry into the entries" do
      expect { MenuStructure.add("path/", "Entry") }.to change { MenuStructure.entries.size }.from(0).to(1)
    end

    it "should add the created entry" do
      entry = MenuStructure.add("path/", "Entry")
      expect(MenuStructure.entries.first).to be entry
    end

  end

  describe ".load_entries" do

    before :each do
      @old_entries = MenuStructure.entries
    end

    after :each do
      MenuStructure.entries = @old_entries
    end

    it "should eval the given block on class level" do
      MenuStructure.load_entries do
        add("/path", "Dummy")
      end
      expect(MenuStructure.entries.map(&:name)).to eq ["Dummy"]
    end

  end

  describe "active" do

    before :each do
      @old_entries = MenuStructure.entries
    end

    after :each do
      MenuStructure.entries = @old_entries
    end

    before :each do
      MenuStructure.load_entries do
        create("/my_entry", "First") do
          add("/my_second_entry", "Second")
        end
      end
    end

    it "should return an entry" do
      expect(MenuStructure.active("/my_entry")).to be_a MenuStructure::Entry
    end

    it "returns the expected entry" do
      expect(MenuStructure.active("/my_entry").name).to eq "First"
    end

  end

end
