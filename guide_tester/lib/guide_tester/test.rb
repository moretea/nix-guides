require_relative "test/parser"
require_relative "test/steps"
require_relative "test/test_case"
require_relative "test/token"
require_relative "test/span"
require_relative "test/runner"

module GuideTester
  class Test
    attr_reader :name

    def self.from_markdown(name, markdown)
      test_cases = Parser.new(markdown, name).parse!
      Test.new(name, test_cases)
    end

    def initialize(name, test_cases)
      @name = name
      @test_cases = test_cases
    end

    def nix_file_name
      @name + ".nix"
    end

    def generate!(dir)
      path = File.join(dir, nix_file_name)
      File.open(path, "w") do |manifest|
        manifest.puts "{"
        @test_cases.each_with_index do |test_case, idx|
          name = "test-case-#{idx}";
          test_case_json_name = @name + "-" + name + ".json"
          test_case_json_path = File.join(dir, test_case_json_name)
          manifest.puts "  #{name} = ./#{test_case_json_name};";
          File.write(test_case_json_path, test_case.to_json)
        end
        manifest.puts "}"
      end
    end
  end
end
