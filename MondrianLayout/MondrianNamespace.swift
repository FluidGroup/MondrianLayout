import UIKit

public struct MondrianNamespace<Base> {

  public let base: Base

  init(base: Base) {
    self.base = base
  }
}

extension UIView {

  public var mondrian: MondrianNamespace<UIView> {
    return .init(base: self)
  }

}
