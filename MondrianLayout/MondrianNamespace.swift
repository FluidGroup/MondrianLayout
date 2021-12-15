import UIKit

public struct MondrianNamespace<Base> {

  public let base: Base

  init(base: Base) {
    self.base = base
  }
}

extension MondrianNamespace where Base: UIView {

  /**
   Entry point to describe layout constraints
   Activates by calling `activate()` or using `mondrianBatchLayout`

   ```swift
   view.mondrian.layout
   .top(.toSuperview)
   .left(.toSuperview)
   .right(.to(box2).left)
   .bottom(.to(box2).bottom)
   .activate()
   ```
   */
  public var layout: LayoutDescriptor {
    .init(view: base)
  }
//
//  public var block: ViewBlock {
//    .init(base)
//  }

}

extension MondrianNamespace where Base: UILayoutGuide {

  /**
   Entry point to describe layout constraints
   Activates by calling `activate()` or using `mondrianBatchLayout`

   ```swift
   view.mondrian.layout
   .top(.toSuperview)
   .left(.toSuperview)
   .right(.to(box2).left)
   .bottom(.to(box2).bottom)
   .activate()
   ```
   */
  public var layout: LayoutDescriptor {
    .init(layoutGuide: base)
  }
//
//  public var block: LayoutGuideBlock {
//    .init(base)
//  }

}
