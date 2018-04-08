# IBDecodable
[![Build Status](https://travis-ci.org/IBDecodable/IBDecodable.svg?branch=master)](https://travis-ci.org/IBDecodable/IBDecodable)
[![Swift 4.0](https://img.shields.io/badge/Swift-4.0-orange.svg?style=flat)](https://developer.apple.com/swift/)

A tool to translate `.xib` and `.storyboard` XML into Swift models.

## Parse Storyboard from file URL 
```swift
let file = try StoryboardFile(url: fileURL)
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

## Parse Xib from file URL 
```swift
let file = try XibFile(url: fileURL)
```
