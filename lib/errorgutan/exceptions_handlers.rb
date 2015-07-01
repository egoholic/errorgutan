module Errorgutan
  class ExceptionsHandlers
    include Utils

    def initialize(default:)
      raise ArgumentError unless handler?(default)

      @map = {}
      @default = default
    end

    def handle(*exception_classes, with:)
      raise ArgumentError unless exception_classes?(exception_classes)
      raise ArgumentError unless handler?(with)

      exception_classes.each { |e| @map[e] = with }
    end

    def [](exception_class)
      raise ArgumentError unless exception_class?(exception_class)

      @map.fetch(exception_class, @default)
    end
  end
end
