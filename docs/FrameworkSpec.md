# FrameworkSpec Syntax Reference

The `FrameworkSpec` is a file that describes how to create a project file for a [multiplatform, single-scheme Xcode project](http://promisekit.org/news/2016/08/Multiplatform-Single-Scheme-Xcode-Projects/).

## Project

A project contains all the information to generate a project file. A `FrameworkSpec` automatically creates a project so its properties can be accessed directly. All properties need to be set in order for the project to be generated properly.

### Properties

#### Name

The name that will be for the project file.

```ruby
project.name = "Project"
```

#### Targets

An array of [targets](#target) that the framework will create.

```ruby
target = new_target do |target|
  target.name = "Target"
  target.info_plist = "Sources/Supporting Files/Info.plist"
  target.bundle_id = "com.org.target"
  target.header = "Sources/Supporting Files/Target.h"
  target.include_files = ["Sources/**/*.swift"]
  target.language = swift("3.0")
  target.platforms = [
    macos("10.11"),
    ios("8.0"),
    tvos("9.0"),
    watchos("2.0")
  ]
end

project.targets = [target]
```

#### Scripts Directory

The directory to save scripts to.

```ruby
project.scripts_directory = "scripts"
```

## Target

A target contains the information that is needed to generate an xcode target inside of an Xcode project. 

### Properties

#### Name 

The name of the target that will be generated.

```ruby
target = new_target do |target|
  target.name = "Target"
end
```
#### Language

The [language](#language-1) that the target will support.

```ruby
target = new_target do |target|
  target.language = swift("3.0")
end
```

#### Platforms

An array of [platforms](#platform) that the target will support.

```ruby
target = new_target do |target|
  target.platforms = [
    macos("10.11"),
    ios("8.0"),
    tvos("9.0"),
    watchos("2.0")
  ]
end
```

#### Info Plist

The path to the target's `info.plist` file.

```ruby
target = new_target do |target|
  target.info_plist = "Sources/Supporting Files/Info.plist"
end
```

#### Bundle Id

The target's bundle id.

```ruby
target = new_target do |target|
  target.bundle_id = "com.org.target"
end
```

#### Header

The target's framework header.

```ruby
target = new_target do |target|
  target.header = "Sources/Supporting Files/Target.h"
end
```

#### Include Files

An array for the source files to be included in the target. Patterns can be used to automatically find all files matching the pattern.

```ruby
target = new_target do |target|
  target.include_files = ["Sources/**/*.swift", "ThirdParty/**/*.swift"]
end
```

#### Exclude Files

An array for the source files to be excluded from the target. Patterns can be used to automatically find all files matching the pattern.

```ruby
target = new_target do |target|
  target.exclude_files = ["Sources/**/*_old.swift", "ThirdParty/**/*_old.swift"]
end
```

#### Resource Files

An array for the resouce files to be included from the target. Patterns can be used to automatically find all files matching the pattern.

```ruby
target = new_target do |target|
  target.resource_files = ["Images/**/*.png"]
end
```

#### Dependencies

An array for the dependencies a target has. If a dependency's name matches the name of another target in the `FrameworkSpec` then it will be used. Otherwise all dependencies are assumed to come from the carthage build folder.

```ruby
dependency = new_target do |target|
  target.name = "Dependency"
end

target = new_target do |target|
  target.dependencies = ["Dependency", "Alamofire"]
end
```

#### Type

The type of target to generate. The default value is `:framework` and the possible values include: `:framework` and `:unit_test_bundle`.

```ruby
target = new_target do |target|
  target.type = :framework
end
```

#### Pre Build Scripts

An array of [scripts](#script) to run before building the target builds.

```ruby
hello_world = new_script do |script|
  script.name = "Hello World"
  script.script = 'echo "hello world"'
end

target = new_target do |target|
  target.pre_build_scripts = [
    hello_world
  ]
end
```

#### Post Build Scripts

An array of [scripts](#script) to run after building the target.

```ruby
hello_world = new_script do |script|
  script.name = "Hello World"
  script.script = 'echo "hello world"'
end

target = new_target do |target|
  target.post_build_scripts = [
    hello_world
  ]
end
```

#### Test Target

Linking a test bundle to a target to be able to run the test action in Xcode.

```ruby
test_target = new_target do |target|
  target.type = :unit_test_bundle
end

target = new_target do |target|
  target.test_target = test_target
end
```

#### Is Safe For Extensions

Set whether the target uses only extension safe apis. The default value is `false` and the possible values include: `true` and `false`.

```ruby
target = new_target do |target|
  target.is_safe_for_extensions = true
end
```

#### Enable Code Coverage

Set whether the target should generate code coverage data when tests are run. The default value is `false` and the possible values include: `true` and `false`.

```ruby
target = new_target do |target|
  target.enable_code_coverage = true
end
```

## Platform

Describes the platform constraints the framework will target. Syntactic sugar for the platform can also be used for the platform like follows:

```ruby
macos("10.11")
ios("8.0")
tvos("9.0")
watchos("2.0")
```

### Properties

#### Type

The type of the platform to target. The possible values are: `:macos`, `:ios`, `:tvos` and `watchos`.

```ruby
macos = new_platform do |platform|
  platform.type = :macos
end
```

#### Minimum Version

The minimun deployment version of the platform for the target.

```ruby
macos = new_platform do |platform|
  platform.minimum_version = "8.0"
end
```

#### Search Paths

Sets the framework search paths for the project. The default value is setup to use the carthage build folder.

```ruby
macos = new_platform do |platform|
  platform.search_paths = "$(SRCROOT)/Carthage/Build/Mac/ $(inherited)"
end
```

## Language

Describes the language constraints the framework will target. Syntactic sugar for the platform can also be used for the platform like follows:

```ruby
swift "3.0"
objc
```

### Properties

#### Type

The type of the platform to target. The possible values are: `:swift`, and `objc`.

```ruby
swift = new_language do |language|
  language.type = :swift
end
```

#### Version

Sets the version of the language to use. This setting only applies to the `:swift` type.

```ruby
swift = new_language do |language|
  language.version = "3.0"
end
```

## Script

Describes scripts that can be added to a target.

### Properties

#### Name

The name of the script that will be shown in the target's build phases in the Xcode project.

```ruby
hello_world = new_script do |script|
  script.name = "Hello World"
end
```

#### Script

The contents of the script that will be executed.

```ruby
hello_world = new_script do |script|
  script.script = "echo 'hello world'"
end
```

#### Inputs

An array of inputs to pass to the executed script.

```ruby
hello_world = new_script do |script|
  script.inputs = ["hello", "world"]
end
```
