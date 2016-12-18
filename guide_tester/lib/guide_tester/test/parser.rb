module GuideTester
  class Test
    class Parser
      class Token < Struct.new(:kind, :data, :span)
      end

      def initialize(content, name)
        @lines = content.split("\n")
        @name = name
      end

      TOKENS = {
        start_test_case: /^<!-- ?start-test "(?<test_name>.*)" ?-->/,
        end_test_case:  /^<!-- ?end-test "(?<test_name>.*)" ?-->/,
        write_file: /^<!-- ?write-file "(?<file_name>.*)" ?-->/,
        start_end_source: /^```/,
        start_test: /^<!-- ? test/,
        end_test: /^-->/
      }

      def parse!
        @idx = 1
        tests = []
        state = :outer
        current_test = nil
        @current_test_start = nil
        
        while (token = next_token).kind != :eof
          case state
          when :outer
            case token.kind
              when :text then next
              when :start_test_case
                current_test = TestCase.new(token.data[:test_name])
                @current_test_start = @idx
                state = :in_test
              else raise_unspected_token!(token)
            end
          when :in_test
            case token.kind
              when :text, :test_line then next
              when :write_file
                lang_token = next_token
                if lang_token.kind != :start_end_source
                  raise_unspected_token!(lang_token)
                end
                file_content = []
                while (line_token = next_token)
                  case line_token.kind
                    when :text then file_content.push line_token.data[:line]
                    when :start_end_source
                      current_test.steps.push Steps::WriteFile.new(Span.new(@name,token.span, line_token.span), token.data[:file_name], file_content.join("\n"))
                      @state = :in_test
                      break
                    else raise_unspected_token!(line_token, [:text, :start_end_source])
                  end
                end
              when :start_test
                test_content = []
                while (line_token = next_token)
                  case line_token.kind
                    when :text then test_content.push line_token.data[:line]
                    when :end_test
                      current_test.steps.push Steps::Test.new(Span.new(@name,token.span, line_token.span), test_content.join("\n"))
                      @state = :in_test
                      break
                    else raise_unspected_token!(line_token, [:text, :end_test])
                  end
                end
              when :end_test_case
                end_name = token.data[:test_name]
                if current_test.name != end_name
                  raise ParseError.new(@name, "Test case ending on line #{token.span.inspect} does not have the same name as it's matching start on line #{@current_test_start}")
                end
                tests.push current_test
                current_test = nil
                @current_test_start = nil
                state = :outer
              else raise_unspected_token!(token)
            end
          else
            raise RuntimeError.new("Unhandled state #{state}")
          end
        end

        tests
      end

      private

      def raise_unspected_token!(token, but_expected=nil)
        msg = "Unexpected #{token.kind.inspect} on line #{token.span.inspect}"
        if @current_test_start != nil
          msg << "; current test started on line #{@current_test_start}"
        end
        if but_expected
          msg << " expected any of #{but_expected.inspect}"
        end
        raise ParseError.new(@name, msg)
      end

      def raise_unexpected_eof!
        raise ParseError.new(@name, "Unexpected end of file")
      end

      def next_token
        line_number = @idx
        line = @lines[line_number]
        if line.nil?
          return Token.new(:eof, nil)
        end

        @idx+=1

        TOKENS.each do |token, regex|
          match = regex.match(line)
          if match
            params= {}
            match.names.each do |name|
              params[name.to_sym] =  match[name]
            end
            return Token.new(token, params, line_number)
          end
        end

        Token.new(:text, {line: line}, line_number)
      end
    end
  end
end
