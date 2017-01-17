# framework-generate
Simple tool to help generate Xcode framework projects for all targets at once

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

`framework-generate` will look for a `FrameworkSpec` file in the current folder to generate your Xcode project. An example of a `FrameworkSpec` can be found in the `docs` folder of this repoisitory.

## Todo

- [ ] Add documentation
- [ ] Add tests
- [ ] Release 1.0

## License

MIT