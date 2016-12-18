module GuideTester
  class Test
    class Token < Struct.new(:kind, :data, :span)
    end
  end
end
