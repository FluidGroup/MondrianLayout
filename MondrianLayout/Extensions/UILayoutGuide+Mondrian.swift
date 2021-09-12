import UIKit

extension UILayoutGuide {

  public var mondrian: MondrianNamespace<UILayoutGuide> {
    return .init(base: self)
  }

  public var layoutGuideBlock: LayoutGuideBlock {
    .init(self)
  }
}
