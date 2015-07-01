module Errorgutan
  class Handler
    include Utils

    def initialize(&handler)
      raise ArgumentError unless block_given?

      @handler = handler
    end

    def handle(exception)
      raise ArgumentError unless exception?(exception)

      @handler.call(exception)
    end
  end
end
