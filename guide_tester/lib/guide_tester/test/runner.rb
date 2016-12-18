module GuideTester
  class Test
    class Runner
      def initialize(json_steps)
        @steps = json_steps.map { |hash| Test::Steps.from_hash(hash) }
      end

      def run!
        @steps.each do |step|
          case step
            when Steps::WriteFile then write_file(step)
            when Steps::Test then run_test(step)
            else raise("Unknown step kind #{step}")
          end
        end
      end

      private

      def write_file(step)
        puts "Writing file #{step.name} (#{step.span.to_s})"
        File.write(step.name, step.content)
      end

      def run_test(step)
        puts "Running test (#{step.span.to_s})"
        system(step.script)
        if $?.exitstatus != 0
          raise RunError.new("Running test step #{step.span.to_s} failed with status code #{$?.exitstatus}!")
        end
      end
    end
  end
end
