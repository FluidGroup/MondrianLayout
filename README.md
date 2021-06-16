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

**VStackBlock**

Alignment 
| center(default) | leading | trailing | fill |
|---|---|---|---|
|<img width="155" alt="CleanShot 2021-06-17 at 00 06 10@2x" src="https://user-images.githubusercontent.com/1888355/122244438-d75b4f80-ceff-11eb-90ea-8982758ed0b0.png">|<img width="151" alt="CleanShot 2021-06-17 at 00 05 19@2x" src="https://user-images.githubusercontent.com/1888355/122244276-b7c42700-ceff-11eb-90d0-492c3fbc5076.png">|<img width="159" alt="CleanShot 2021-06-17 at 00 05 33@2x" src="https://user-images.githubusercontent.com/1888355/122244312-c01c6200-ceff-11eb-888d-0a37b63f666a.png">|<img width="159" alt="CleanShot 2021-06-17 at 00 05 42@2x" src="https://user-images.githubusercontent.com/1888355/122244341-c6124300-ceff-11eb-9da8-dcbb4425909a.png">|

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
