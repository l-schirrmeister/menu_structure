# encoding: utf-8
require_relative 'menu_structure/entry'
require_relative 'menu_structure/load_context'
require_relative 'menu_structure/path'

module MenuStructure

  include ActiveSupport::Configurable

  config_accessor(:internal_path_splitter) do
    ->(path) { Rails.application.routes.recognize_path(path) }
  end

  mattr_writer :entries, :children

  class << self

    def entries
      @@entries ||= []
    end

    def children
      @@children ||= entries.map(&:children).flatten.compact
    end

    def add *args, &block
      entries << (entry = ::MenuStructure::Entry.new(nil, *args, &block))
      entry
    end
    alias_method(:create, :add)

    def load_entries &block
      self.entries = []
      self.children = nil
      ::MenuStructure::LoadContext.new(self).instance_eval(&block)
      true
    end

    def active(path)
      entries.detect { |entry| entry.active?(path) }
    end

  end

end
