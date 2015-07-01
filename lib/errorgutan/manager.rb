module Errorgutan
  require "errorgutan/utils"
  require "errorgutan/aliases"
  require "errorgutan/exceptions_handlers"
  require "errorgutan/handler"
  require "errorgutan/exception_factory"

  class Manager
    def initialize(aliases, exceptions_handlers)
      raise ArgumentError unless aliases.instance_of?(Aliases)
      raise ArgumentError unless exceptions_handlers.instance_of?(ExceptionsHandlers)

      @aliases = aliases
      @exceptions_handlers = exceptions_handlers
    end

    def manage
      yield
    rescue Exception => exception
      aliased_exception = make_new_exception_from(exception)

      handle_exception aliased_exception
    end

    private

    def alias_for(exception_class)
      @aliases[exception_class] || exception_class
    end

    def make_new_exception_from(exception)
      exception_class = alias_for(exception.class)
      ExceptionFactory.build exception_class, exception
    end

    def handle_exception(exception)
      handler = @exceptions_handlers[exception.class]
      handler.handle exception
    end
  end
end
