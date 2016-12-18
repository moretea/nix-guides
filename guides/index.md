# Nix Guides

Welcome to Nix Guides!
With this set of guides targetted at new Nix users, we hope to give a gentle introduction to the 
Nix universe.

Our goal is to have a set of guides that take you, the end-user, through all the steps you need
in a sequential order to accomplish certain tasks.
The Nix, Nixpkgs, and NixOs manuals are great as reference manuals, but are to detailed to use
as learning material.

### Why bother learning Nix?
We believe that Nix has a unique value proposition.It offers **declarative specifications** of
software packages, machine configurations and even cloud resources. 
Because of these declarative specifications, we have **repreducible builds**, not just of
software packages, but also of complete machines and cluster configurations [^1].
This can be used to have *identical environments* in production and development, and among the
different machines used by developers.
It is **reliable**, by not ever replacing components. This makes **atomic upgrades and rollbacks**
easy and safe, in contrast to most distributions, where updates can break the OS if it's
interrupted at the wrong time.

### What to read next
If you're completely new to Nix, we recommend to take a quick peek at the [Overview](overview.md),
and then follow the [Getting Started Tutorial](getting-started-tutorial.md).
From there on you can pick any guide in any order you like.

[^1]: Cluster configurations are modulo dynamic settings that depend on the cluster environment,
such as the IP address assigned to a VM.
