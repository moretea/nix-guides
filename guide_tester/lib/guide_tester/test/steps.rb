module GuideTester
  class Test
    module Steps
      class WriteFile < Struct.new(:span, :name,:content)
        def to_hash
          { 
            kind: "write_file",
            name: name,
            content: content,
            span: span.to_hash
          }
        end
      end

      class Test < Struct.new(:span, :script)
        def to_hash
          { 
            kind: "test",
            script: script,
            span: span.to_hash
          }
        end
      end

      def self.from_hash(hash)
        case hash["kind"]
          when "write_file" then WriteFile.new(Span.from_hash(hash["span"]), hash["name"], hash["content"])
          when "test" then Test.new(Span.from_hash(hash["span"]), hash["script"])
          else raise InputError.new("Unknown step kind #{hash["kind"].inspect}")
        end
      end
    end
  end
end
