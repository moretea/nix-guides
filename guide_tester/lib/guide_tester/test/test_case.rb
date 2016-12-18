module GuideTester
  class Test
    class TestCase
      attr_reader :name
      attr_accessor :steps

      def initialize(name)
        @name = name
        @steps = []
      end

      def to_json
        JSON.pretty_generate(@steps.map { |step| step.to_hash })
      end
    end
  end
end
