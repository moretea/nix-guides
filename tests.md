# Guide Tests

This basically works in two steps:
1. First JSON files are [generated](guide_tester/exe/gen_tests) from the annotations embedded in 
   the Markdown of the Guides.
2. Next, the `makeTest` infrastructure is used to create a VM.
   A [runner script](guide_tester/exe/runner) interprets the steps in this JSON file from within
   the QEMU VM

## Syntax of tests
Only Markdown files with a  YAML header containing `runGuideTests: true` will be converted into
tests. For an example, see the [getting-started](guides/getting-started-tutorial.md) documentation.

Each guide can have multiple test secions, each of which starts a new VM test.
Within each section, there are steps to e.g. write files and run shell code.

### Test sections
All steps must be embedded in a `test` section, which is delimited by 
`<!-- start-test "mytestname" -->` and 
`<!-- end-test "mytestname" -->`. Note that a) this must be at the start of the line, and b),
the names must match.

At the moment, there are two supported steps: `write-file` and `test`.

### The `write-file` step
The `write-file` step is an annotation around a Markdown code block.

Example:
````
<!-- write-file "hello.nix" -->
```nix
with import <nixpkgs> {};
{
  hello = stdenv.mkDerivation {
    name = "hello";
    src = ./hello.c;
  };
}
```
````

Note: it is possible to overwrite existing files. This can be handy to iteratively improve
some script.

Note: Code highlighting uses the `CodeHilite` plugin from Python's Markdown parser. It supports
adding a different background color to code lines that can be used to draw attention to e.g. 
changes compared to the previous version of a file. See the 
[documentation of CodeHilite](https://pythonhosted.org/Markdown/extensions/code_hilite.html#colons)
for the exact details.

