# framework-generate
[![Gem](https://img.shields.io/gem/v/framework-generate.svg?style=flat)](https://rubygems.org/gems/framework-generate)

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

## Todo

- [X] Add documentation
- [ ] Add tests
- [ ] Release 1.0

## License

This project is licensed under the terms of the MIT license. See the [LICENSE](LICENSE) file.
