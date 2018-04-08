# IBDecodable

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
