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
      @original_class = original_exception.class
      @original_message = original_exception.message
      @original_backtrace = original_exception.backtrace
    end

    def exception
      @exception = @exception_class.new(@original_message)
      @exception.set_backtrace @original_backtrace

      return @exception
    end
  end
end
