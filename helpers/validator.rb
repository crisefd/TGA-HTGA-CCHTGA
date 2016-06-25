module Validator
  class ValidationError < ArgumentError; end

  refine Module do
    def validate(*methods, &validator)
      prepend(Module.new do
        methods.each do |method|
          define_method(method) do |*args, &blk|
            raise ValidationError, args.inspect unless yield *args
            super(*args, &blk)
          end
        end
      end)
    end
  end
end
