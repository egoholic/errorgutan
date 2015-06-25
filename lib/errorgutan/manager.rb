module Errorgutan
  require "errorgutan/aliases"
  require "errorgutan/exceptions_handlers"
  require "errorgutan/handler"
  require "errorgutan/exception_factory"

  class Manager
    def initialize(aliases, exceptions_handlers)
      raise ArgumentError unless aliases.is_a?(Errorgutan::Aliases)
      raise ArgumentError unless exceptions_handlers.is_a?(Errorgutan::ExceptionsHandlers)

      @aliases = aliases
      @exceptions_handlers = exceptions_handlers
    end

    def manage
      yield if block_given?
    rescue Exception => exception
      original_exception_class = exception.class
      exception_class = alias_for(original_exception_class) || original_exception_class
      aliased_exception = make_exception(exception_class, exception)

      handle_exception aliased_exception
    end

    private

    def alias_for(exception_class)
      @aliases[exception_class] || exception_class
    end

    def make_exception(exception_class, original_exception)
      ExceptionFactory.build exception_class, original_exception
    end

    def handle_exception(exception)
      handler = @exceptions_handlers[exception.class]
      handler.handle exception
    end
  end
end
