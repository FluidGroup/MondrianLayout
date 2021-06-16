# MondrianLayout - (Under development)

<img width="286" alt="CleanShot 2021-06-16 at 21 59 59@2x" src="https://user-images.githubusercontent.com/1888355/122223608-4af46100-ceee-11eb-9bc1-364c9ddec5c6.png">

A DSL based layout builder with AutoLayout

> 🧦 Currently still in development
> And I'm not sure if my idea goes true.

## Introduction

AutoLayout is super powerful to describe the layout and how it changes according to the bounding box.  
What if we get a more ergonomic interface to declare the constraints.

## Overview

```swift
class MyView: UIView {

  let nameLabel: UILabel
  let detailLabel: UILabel

  init() {
    super.init(frame: .zero)
    
    // Set constraints, layoutGuides and adding subviews
    buildSublayersLayout {
      VStackBlock {
        nameLabel
        detailLabel
      }
    }
  }
}
```

## Detail

* VStackBlock
* HStackBlock
* ZStackBlock

## Installation

**CocoaPods**

```ruby
pod "MondrianLayout"
```

**SwiftPM**

dependencies: [
    .package(url: "https://github.com/muukii/MondrianLayout.git", exact: "<VERSION>")
]

## LICENSE

MondrianLayout is released under the MIT license.
