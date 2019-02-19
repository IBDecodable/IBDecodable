# IBDecodable
[![Build Status](https://travis-ci.org/IBDecodable/IBDecodable.svg?branch=master)](https://travis-ci.org/IBDecodable/IBDecodable)
[![Swift 4.0](https://img.shields.io/badge/Swift-4.0-orange.svg?style=flat)](https://developer.apple.com/swift/)

A tool to translate `.xib` and `.storyboard` XML into Swift models.

## Installing

### Using [Cocoapods](https://cocoapods.org/):

Simply add the following line to your Podfile:

```
pod 'IBDecodable'
```

### Using [Swift Package Manager](https://swift.org/package-manager/):

To include IBDecodable into a Swift Package Manager package, add it to the dependencies attribute defined in your `Package.swift` file.

```
dependencies: [
    .Package(url: "https://github.com/IBDecodable/IBDecodable.git", majorVersion: <majorVersion>, minor: <minor>)
]
```

## Parse Storyboard

From file url:
```swift
let file = try StoryboardFile(url: fileURL)
```

From string content:
```swift
let parser = InterfaceBuilderParser()
let storyboardDocument = try parser.parseStoryboard(xml: "<?xml ... ")
```

### Browse the storyboard scene

```swift
if let scenes = file.document.scenes {
  for scene in scenes {
    ..
  }
}
```

### Get the storyboard resources

```swift
if let resources = file.document.resources {
  for resource in resources {
    resource.resource // .. `NamedColor`, Ìmage
  }
}
```

## Parse Xib

From file url:
```swift
let file = try XibFile(url: fileURL)
```

From string content:
```swift
let parser = InterfaceBuilderParser()
let xibDocument = try parser.parseXib(xml: "<?xml ... ")
```
