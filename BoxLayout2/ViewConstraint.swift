import UIKit

struct DimensionDescriptor {
  let constant: CGFloat
  let priority: UILayoutPriority
}

public struct ViewConstraint: _RelativeContentConvertible {

  public var _relativeContent: _RelativeContent {
    return .view(self)
  }

  public let view: UIView

  var aspectRatio: DimensionDescriptor?

  var minHeight: DimensionDescriptor?
  var minWidth: DimensionDescriptor?

  var maxHeight: DimensionDescriptor?
  var maxWidth: DimensionDescriptor?

  var height: DimensionDescriptor?
  var width: DimensionDescriptor?

  var verticalHuggingPriority: UILayoutPriority?
  var horizontalHuggingPriority: UILayoutPriority?

  var verticalCompressionResistancePriority: UILayoutPriority?
  var horizontalCompressionResistancePriority: UILayoutPriority?

  public init(
    _ view: UIView
  ) {
    self.view = view
  }

  public func huggingPriority(
    _ axis: NSLayoutConstraint.Axis,
    _ priority: UILayoutPriority = .required
  ) -> Self {
    _modify {
      switch axis {
      case .horizontal:
        $0.horizontalHuggingPriority = priority
      case .vertical:
        $0.verticalHuggingPriority = priority
      @unknown default:
        assertionFailure()
      }
    }
  }

  public func compressionResistancePriority(
    _ axis: NSLayoutConstraint.Axis,
    _ priority: UILayoutPriority = .required
  ) -> Self {
    _modify {
      switch axis {
      case .horizontal:
        $0.horizontalCompressionResistancePriority = priority
      case .vertical:
        $0.verticalCompressionResistancePriority = priority
      @unknown default:
        assertionFailure()
      }
    }
  }

  public func aspectRatio(_ ratio: CGFloat, priority: UILayoutPriority = .required) -> Self {
    _modify {
      $0.aspectRatio = .init(constant: ratio, priority: priority)
    }
  }

  public func aspectRatio(_ size: CGSize) -> Self {
    aspectRatio(size.width / size.height)
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

  public func makeApplier() -> () -> Void {

    return { [weak view] in

      guard let view = view else { return }

      if let priority = verticalHuggingPriority {
        view.setContentHuggingPriority(priority, for: .vertical)
      }
      if let priority = horizontalHuggingPriority {
        view.setContentHuggingPriority(priority, for: .horizontal)
      }
      if let priority = verticalCompressionResistancePriority {
        view.setContentCompressionResistancePriority(priority, for: .vertical)
      }
      if let priority = horizontalCompressionResistancePriority {
        view.setContentCompressionResistancePriority(priority, for: .vertical)
      }
    }
  }

  public func makeConstraints() -> [NSLayoutConstraint] {
    var constraint: [NSLayoutConstraint] = []

    if let height = height {
      constraint.append(
        view.heightAnchor.constraint(equalToConstant: height.constant).withPriority(height.priority)
          .withIdentifier("ViewConstraints.height")
      )
    }

    if let width = width {
      constraint.append(
        view.widthAnchor.constraint(equalToConstant: width.constant).withPriority(width.priority)
          .withIdentifier("ViewConstraints.width")
      )
    }

    if let minHeight = minHeight {
      constraint.append(
        view.heightAnchor.constraint(greaterThanOrEqualToConstant: minHeight.constant).withPriority(
          minHeight.priority
        ).withIdentifier("ViewConstraints.minHeight")
      )
    }

    if let width = minWidth {
      constraint.append(
        view.widthAnchor.constraint(greaterThanOrEqualToConstant: width.constant).withPriority(
          width.priority
        ).withIdentifier("ViewConstraints.minWidth")
      )
    }

    if let height = maxHeight {
      constraint.append(
        view.heightAnchor.constraint(lessThanOrEqualToConstant: height.constant).withPriority(
          height.priority
        ).withIdentifier("ViewConstraints.maxHeight")
      )
    }

    if let width = maxWidth {
      constraint.append(
        view.widthAnchor.constraint(lessThanOrEqualToConstant: width.constant).withPriority(
          width.priority
        ).withIdentifier("ViewConstraints.maxWdith")
      )
    }

    if let aspectRatio = aspectRatio {
      constraint.append(
        view.widthAnchor.constraint(equalTo: view.heightAnchor, multiplier: aspectRatio.constant)
          .withPriority(aspectRatio.priority).withIdentifier("ViewConstraints.aspectRatio")
      )
    }

    return constraint
  }

}
