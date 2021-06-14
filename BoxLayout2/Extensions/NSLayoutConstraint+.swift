import UIKit

extension NSLayoutConstraint {

  func withInternalIdentifier(_ string: String) -> NSLayoutConstraint {
    self.identifier = "BoxLayout." + string
    return self
  }


  func withIdentifier(_ string: String) -> NSLayoutConstraint {
    self.identifier = string
    return self
  }

  func withPriority(_ priority: UILayoutPriority) -> NSLayoutConstraint {
    self.priority = priority
    return self
  }

}
