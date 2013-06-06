module MenuStructure

  class LoadContext

    attr_reader :_menu
    delegate :add, :create, to: :_menu

    def initialize(_menu)
      @_menu = _menu
    end

  end

end
