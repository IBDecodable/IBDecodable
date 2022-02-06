# IBDecodable
[![Swift](https://github.com/IBDecodable/IBDecodable/actions/workflows/swift.yml/badge.svg)](https://github.com/IBDecodable/IBDecodable/actions/workflows/swift.yml)
[![Swift 5.5](https://img.shields.io/badge/Swift-5.5-orange.svg?style=flat)](https://developer.apple.com/swift/)
[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![MIT License][license-shield]][license-url]

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

<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[contributors-shield]: https://img.shields.io/github/contributors/IBDecodable/IBDecodable.svg?style=flat
[contributors-url]: https://github.com/IBDecodable/IBDecodable/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/IBDecodable/IBDecodable.svg?style=flat
[forks-url]: https://github.com/IBDecodable/IBDecodable/network/members
[stars-shield]: https://img.shields.io/github/stars/IBDecodable/IBDecodable.svg?style=flat
[stars-url]: https://github.com/IBDecodable/IBDecodable/stargazers
[issues-shield]: https://img.shields.io/github/issues/IBDecodable/IBDecodable.svg?style=flat
[issues-url]: https://github.com/IBDecodable/IBDecodable/issues
[license-shield]: https://img.shields.io/github/license/IBDecodable/IBDecodable.svg?style=flat
[license-url]: https://github.com/IBDecodable/IBDecodable/blob/master/LICENSE.md
