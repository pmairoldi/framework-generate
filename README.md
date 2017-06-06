# framework-generate
[![Gem Version](https://badge.fury.io/rb/framework-generate.svg)](https://badge.fury.io/rb/framework-generate)
[![License](https://img.shields.io/badge/license-MIT-green.svg?style=flat)](LICENSE)

Simple tool to help generate a [multiplatform, single-scheme Xcode project](http://promisekit.org/news/2016/08/Multiplatform-Single-Scheme-Xcode-Projects/).

## Installation

Add this line to your Gemfile:

```rb
gem 'framework-generate'
```

## Usage

Once installed you can run the generate command from the command line as follows

```bash
framework-generate
```

`framework-generate` will look for a `FrameworkSpec` file in the current folder to generate your Xcode project. An example of a `FrameworkSpec` can be found in the [`docs`](docs/FrameworkSpec) folder of this repoisitory.

To view the full `FrameworkSpec` documentation see the [`docs`](docs/FrameworkSpec.md) folder.

## Contributing

Love framework-generate but want to make it even better?

Open source isn't just writing code. We could use your help with any of the
following:

- Finding (and reporting!) bugs.
- New feature suggestions.
- Answering questions on issues.
- Documentation improvements.
- Reviewing pull requests.
- Helping to manage issue priorities.
- Fixing bugs/new features.

If any of that sounds cool to you, send a pull request! After a few
contributions, we'll add you as an admin to the repo so you can merge pull
requests and help build framework-generate.

Please note that this project is released with a Contributor Code of Conduct. By participating in this project you agree to abide by [its terms](CODE_OF_CONDUCT.md).

### How to contribute

Contributing is easy. Simply make your changes to the tool and then try it out using: 

```bash
ruby -Ilib ./bin/framework-generate
```

Once your change is good to go open up a pull request!

For more information on running executables in ruby please see the [ruby gems documentation](http://guides.rubygems.org/make-your-own-gem/#adding-an-executable).

## License

This project is licensed under the terms of the MIT license. See the [LICENSE](LICENSE) file.
