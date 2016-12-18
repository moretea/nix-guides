module GuideTester
  class Test
    class Span
      def self.from_hash(hash)
        new(hash["name"], hash["start_line"], hash["end_line"])
      end

      def initialize(name, start_line, end_line=nil)
        @name = name
        @start_line = start_line
        if end_line
          @end_line = end_line
        end
      end

      def to_hash
        {
          name: @name,
          start_line: @start_line,
          end_line: @end_line
        }
      end

      def to_s
        "#{@name}:#{@start_line}-#{@end_line}"
      end
    end
  end
end
