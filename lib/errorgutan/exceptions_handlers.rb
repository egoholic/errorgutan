module Errorgutan
  class ExceptionsHandlers
    def initialize(default:)
      raise ArgumentError if default.nil?

      @map = {}
      @default = default
    end

    def bind(*exceptions, to:)
      exceptions.compact!

      raise ArgumentError if exceptions.empty? || to.nil?

      exceptions.each { |e| @map[e] = to }
    end

    def [](exception)
      @map.fetch(exception, @default)
    end
  end
end
