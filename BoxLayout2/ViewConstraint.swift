
import UIKit

struct DimensionDescriptor {
  let constant: CGFloat
  let priority: UILayoutPriority
}

public struct ViewConstraint {

  public let view: UIView

  var minHeight: DimensionDescriptor?
  var minWidth: DimensionDescriptor?

  var maxHeight: DimensionDescriptor?
  var maxWidth: DimensionDescriptor?

  var height: DimensionDescriptor?
  var width: DimensionDescriptor?

  public init(_ view: UIView) {
    self.view = view
  }

  public func height(_ value: CGFloat, priority: UILayoutPriority = .required) -> Self {
    _modify {
      $0.height = .init(constant: value, priority: priority)
    }
  }

  public func width(_ value: CGFloat, priority: UILayoutPriority = .required) -> Self {
    _modify {
      $0.width = .init(constant: value, priority: priority)
    }
  }

  public func minHeight(_ value: CGFloat, priority: UILayoutPriority = .required) -> Self {
    _modify {
      $0.minHeight = .init(constant: value, priority: priority)
    }
  }

  public func minWidth(_ value: CGFloat, priority: UILayoutPriority = .required) -> Self {
    _modify {
      $0.minWidth = .init(constant: value, priority: priority)
    }
  }

  public func maxHeight(_ value: CGFloat, priority: UILayoutPriority = .required) -> Self {
    _modify {
      $0.maxHeight = .init(constant: value, priority: priority)
    }
  }

  public func maxWidth(_ value: CGFloat, priority: UILayoutPriority = .required) -> Self {
    _modify {
      $0.maxWidth = .init(constant: value, priority: priority)
    }
  }

  public func size(_ size: CGSize, priority: UILayoutPriority = .required) -> Self {
    _modify {
      $0.height = .init(constant: size.height, priority: priority)
      $0.width = .init(constant: size.width, priority: priority)
    }
  }

  private func _modify(_ modifier: (inout Self) -> Void) -> Self {
    var new = self
    modifier(&new)
    return new
  }

  public func makeConstraints() -> [NSLayoutConstraint] {
    var constraint: [NSLayoutConstraint] = []

    if let height = height {
      constraint.append(view.heightAnchor.constraint(equalToConstant: height.constant).withPriority(height.priority))
    }

    if let width = width {
      constraint.append(view.widthAnchor.constraint(equalToConstant: width.constant).withPriority(width.priority))
    }

    if let minHeight = minHeight {
      constraint.append(view.heightAnchor.constraint(greaterThanOrEqualToConstant: minHeight.constant).withPriority(minHeight.priority))
    }

    if let width = minWidth {
      constraint.append(view.widthAnchor.constraint(greaterThanOrEqualToConstant: width.constant).withPriority(width.priority))
    }

    if let height = maxHeight {
      constraint.append(view.heightAnchor.constraint(lessThanOrEqualToConstant: height.constant).withPriority(height.priority))
    }

    if let width = maxHeight {
      constraint.append(view.widthAnchor.constraint(lessThanOrEqualToConstant: width.constant).withPriority(width.priority))
    }

    return constraint
  }

}
