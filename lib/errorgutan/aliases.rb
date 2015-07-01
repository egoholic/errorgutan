module Errorgutan
  class Aliases
    include Utils

    def initialize
      @aliases = {}
    end

    def bind(*exception_classes, with:)
      exception_classes.compact!

      raise ArgumentError unless exception_classes?(exception_classes)
      raise ArgumentError unless exception_class?(with)

      exception_classes.each { |e| @aliases[e] = with }
    end

    def [](exception_class)
      raise ArgumentError unless exception_class?(exception_class)

      @aliases[exception_class]
    end
  end
end