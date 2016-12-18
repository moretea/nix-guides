runGuideTests: true
---

# Getting Started Tutorial

## Get Nix
- Docker Image
- Install on your Linux Distro
- Install NixOS (on a VM)

## Installing a program

## Developing Hello World

### C
<!-- start-test "hello world c" -->
- Create a `hello.c` file with the following contents:

<!-- write-file "hello.c" -->
```c
#include <stdio.h>

int main(int argc, char* argv[]) {
  printf("Hello World!");
  return 0;
}
```

And a nix expression file with the following contents:

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

<!-- test
echo $NIX_PATH
nix-env -qa
nix-env -i neovim
-->

<!-- end-test "hello world c" -->

### Javascript
### Ruby
### Go
### Rust

## Managing a virtual machine
