module GuideTester
  class Error < RuntimeError; end

  class InputError < Error; end

  class ParseError < Error
    def initialize(file, message)
      super("Could not parse #{file}: #{message}")
    end
  end

  class RunError < Error; end
end
