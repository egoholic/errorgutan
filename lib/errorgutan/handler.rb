module Errorgutan
  class Handler
    def initialize(&handler)
      raise ArgumentError unless handler

      @handler = handler
    end

    def handle(exception)
      raise ArgumentError unless exception.is_a? Exception

      @handler.call(exception)
    end
  end
end
