import UIKit

extension NSLayoutConstraint {

  func withIdentifier(_ string: String) -> NSLayoutConstraint {
    self.identifier = identifier
    return self
  }

  func withPriority(_ priority: UILayoutPriority) -> NSLayoutConstraint {
    self.priority = priority
    return self
  }

}
