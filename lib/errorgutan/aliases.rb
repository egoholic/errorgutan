module Errorgutan
  class Aliases
    def initialize
      @aliases = {}
    end

    def bind(*exceptions, with:)
      exceptions.compact!
      raise ArgumentError if exceptions.empty? || !with.is_a?(Class)

      exceptions.each { |e| @aliases[e] = with }
    end

    def [](exception)
      raise ArgumentError unless exception.is_a?(Class)

      @aliases[exception]
    end
  end
end