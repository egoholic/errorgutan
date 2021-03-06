module Errorgutan
  module Utils
    private

    def handler?(obj)
      obj.instance_of? Handler
    end

    def exception?(obj)
      obj.is_a? Exception
    end

    def exception_class?(cls)
      cls.instance_of?(Class) && cls.ancestors.include?(Exception)
    end

    def exception_classes?(list)
      return false unless list.instance_of?(Array)
      return false if list.empty?

      list.all? { |e| exception_class? e }
    end
  end
end
