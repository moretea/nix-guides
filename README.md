# Nix guides

This repository contains an unofficial attempt to have beginner friendly documentation to get
acquanted with the Nix ecosystem. See https://moretea.github.io/nix-guides for a rendered version.

## Adding guides
Each guide should stand on its own; any new concept introduced must either be explained in
the guide itself, or link to another guide or a section in one of the Nix manuals.
The only expected knowledge is the knowledge in the [Overview](guides/overview.md) section.
Furthermore, each guide should have embedded tests that are periodically verified.
See [the documentation](./tests.md) for more information about how this works.

### Formatting

### Development server
Run the following command to start a auto-updating development server.
```bash
$ `nix-build -A dev-server`
```

## Contributing
Bug reports and pull requests are welcome on [GitHub](https://github.com/moretea/nix-guides).
This project is intended to be a safe, welcoming space for collaboration, and contributors are
expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License
All guides are available under the terms of the 
[Creative Commons Attribution 4.0 International (CC BY 4.0)](https://creativecommons.org/licenses/by/4.0/)
license

The guide tester is released under the [AGPL 3.0](https://www.gnu.org/licenses/agpl-3.0.en.html)
