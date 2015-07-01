module Errorgutan
  class ExceptionFactory
    include Utils

    class << self
      def build(exception_class, original_exception)
        new(exception_class, original_exception).exception
      end
    end

    def initialize(exception_class, original_exception)
      raise ArgumentError unless exception_class?(exception_class)
      raise ArgumentError unless exception?(original_exception)

      @exception_class = exception_class
      @original_exception = original_exception
    end

    def exception
      @exception_class.new(@original_exception).tap do |e|
        e.set_backtrace @original_exception.backtrace
      end
    end
  end
end
