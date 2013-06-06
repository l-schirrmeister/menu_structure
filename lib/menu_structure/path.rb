module MenuStructure

  class Path

    attr_reader :options

    def initialize(path_input)
      @path_input = path_input
      @static = !path_input.respond_to?(:call)
      @cache = {}
    end

    def path
      static? ? path_input : path_input.call
    end

    def active? request_path
      !!(request_path.match(path_regexp))
    end

    private

      attr_reader :path_input, :cache

      def static?
        @static
      end

      def path_regexp
        cache_if_static(:path_regexp) { /^#{Regexp.escape(path)}($|\?)/ }
      end

      def cache_if_static key
        return yield if static?
        cache[:key] ||= yield
      end

  end

end
