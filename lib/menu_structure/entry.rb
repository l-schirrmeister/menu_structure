# encoding: utf-8

module MenuStructure

  class Entry

    attr_reader :parent, :name, :options, :path_object

    delegate :action, :active?, :controller, to: :path_object, prefix: :path

    alias_method(:active_path?, :path_active?)

    def initialize(parent, path, name, options = {}, &block)
      @parent, @name, @options = parent, name, options
      @path_object = Path.new(path)
      LoadContext.new(self).instance_eval(&block) if block_given?
    end

    def children
      @children ||= []
    end

    def add *args, &block
      children << (child = self.class.new(self, *args, &block))
      child
    end
    alias_method(:create, :add)

    def path
      path_object.path
    end

    def active? request_path
      active_path?(request_path) || active_child(request_path).present?
    end

    def active_leaf request_path
      if (active_child = active_child(request_path))
        active_child.active_leaf(request_path)
      else
        active_path?(request_path) ? self : nil
      end
    end

    def level
      parent.blank? ? 1 : parent.level + 1
    end

    private

      def active_child request_path
        children.find { |child| child.active?(request_path) }
      end

  end

end
