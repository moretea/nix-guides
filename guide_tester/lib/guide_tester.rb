require "fileutils"
require "json"

require "guide_tester/version"
require "guide_tester/ext_string_colors"
require "guide_tester/errors"
require "guide_tester/test"

module GuideTester
  def self.generate_tests!(output_dir, base_dir, markdown_files)
    tests = markdown_files.map do |md_file|
      name = md_file.gsub(/^#{base_dir}\/?/,"").gsub(/.md$/,"")
      content = File.read(md_file)
      Test.from_markdown(name, content)
    end

    FileUtils.mkdir_p(output_dir)

    tests.map do |test|
      test.generate!(output_dir)
    end

    all = "{\n" + tests.map {|test| " #{test.name} = (import ./#{test.nix_file_name});" }.join("\n") + "\n}\n";
    File.write(File.join(output_dir, "default.nix"), all)
  end
end
