import UIKit

public struct DimensionDescriptor: Equatable {

  public struct ConstraintValue: Equatable {
    public var constant: CGFloat
    public var priority: UILayoutPriority
  }
  
  public var aspectRatio: ConstraintValue?

  public var minHeight: ConstraintValue?
  public var minWidth: ConstraintValue?

  public var maxHeight: ConstraintValue?
  public var maxWidth: ConstraintValue?

  public var height: ConstraintValue?
  public var width: ConstraintValue?

  public func makeConstraints(for view: UIView) -> [NSLayoutConstraint] {
    return makeConstraints(for: .init(view: view))
  }

  public func makeConstraints(for layoutGuide: UILayoutGuide) -> [NSLayoutConstraint] {
    return makeConstraints(for: .init(layoutGuide: layoutGuide))
  }

  func makeConstraints(for view: _LayoutElement) -> [NSLayoutConstraint] {
    var constraint: [NSLayoutConstraint] = []

    if let height = height {
      constraint.append(
        view.heightAnchor.constraint(equalToConstant: height.constant)
          .setPriority(height.priority)
          .setInternalIdentifier("ViewConstraints.height")
      )
    }

    if let width = width {
      constraint.append(
        view.widthAnchor.constraint(equalToConstant: width.constant)
          .setPriority(width.priority)
          .setInternalIdentifier("ViewConstraints.width")
      )
    }

    if let minHeight = minHeight {
      constraint.append(
        view.heightAnchor.constraint(greaterThanOrEqualToConstant: minHeight.constant).setPriority(
          minHeight.priority
        )
        .setInternalIdentifier("ViewConstraints.minHeight")
      )
    }

    if let width = minWidth {
      constraint.append(
        view.widthAnchor.constraint(greaterThanOrEqualToConstant: width.constant).setPriority(
          width.priority
        )
        .setInternalIdentifier("ViewConstraints.minWidth")
      )
    }

    if let height = maxHeight {
      constraint.append(
        view.heightAnchor.constraint(lessThanOrEqualToConstant: height.constant).setPriority(
          height.priority
        )
        .setInternalIdentifier("ViewConstraints.maxHeight")
      )
    }

    if let width = maxWidth {
      constraint.append(
        view.widthAnchor.constraint(lessThanOrEqualToConstant: width.constant).setPriority(
          width.priority
        )
        .setInternalIdentifier("ViewConstraints.maxWdith")
      )
    }

    if let aspectRatio = aspectRatio {
      constraint.append(
        view.widthAnchor.constraint(equalTo: view.heightAnchor, multiplier: aspectRatio.constant)
          .setPriority(aspectRatio.priority)
          .setInternalIdentifier("ViewConstraints.aspectRatio")
      )
    }

    return constraint
  }

}

public protocol _DimensionConstraintType {
  var dimensionConstraints: DimensionDescriptor { get set }
}

extension _DimensionConstraintType {

  fileprivate func _modify(_ modifier: (inout DimensionDescriptor) -> Void) -> Self {
    var new = self
    modifier(&new.dimensionConstraints)
    return new
  }

  /**
   Constrains this view’s dimensions to the aspect ratio of the given size.
   */
  public func aspectRatio(_ ratio: CGFloat, priority: UILayoutPriority = .required) -> Self {
    _modify {
      $0.aspectRatio = .init(constant: ratio, priority: priority)
    }
  }

  /**
   Constrains this view’s dimensions to the aspect ratio of the given size.
   */
  public func aspectRatio(_ size: CGSize) -> Self {
    aspectRatio(size.width / size.height)
  }

  /**
   Adding height constraint

   the constraints can be described for each relations - min, max, exact.
   It does not support that multiple constraints in the same relation.
   */
  public func height(_ value: LayoutDescriptor.ConstraintValue) -> Self {
    switch value.relation {
    case .min:
      return _modify {
        $0.minHeight = .init(constant: value.constant, priority: value.priority)
      }
    case .exact:
      return _modify {
        $0.height = .init(constant: value.constant, priority: value.priority)
      }
    case .max:
      return _modify {
        $0.maxHeight = .init(constant: value.constant, priority: value.priority)
      }
    }
  }

  /**
   Adding height constraint

   the constraints can be described for each relations - min, max, exact.
   It does not support that multiple constraints in the same relation.
   */
  @_disfavoredOverload
  public func height(_ exactValue: CGFloat) -> Self {
    height(.exact(exactValue))
  }

  /**
   Adding width constraint

   the constraints can be described for each relations - min, max, exact.
   It does not support that multiple constraints in the same relation.
   */
  public func width(_ value: LayoutDescriptor.ConstraintValue) -> Self {
    switch value.relation {
    case .min:
      return _modify {
        $0.minWidth = .init(constant: value.constant, priority: value.priority)
      }
    case .exact:
      return _modify {
        $0.width = .init(constant: value.constant, priority: value.priority)
      }
    case .max:
      return _modify {
        $0.maxWidth = .init(constant: value.constant, priority: value.priority)
      }
    }
  }

  /**
   Adding width constraint

   the constraints can be described for each relations - min, max, exact.
   It does not support that multiple constraints in the same relation.
   */
  @_disfavoredOverload
  public func width(_ exactValue: CGFloat) -> Self {
    width(.exact(exactValue))
  }

  /**
   Adding width and height constraint by separated relation and priority.
   */
  public func size(
    width: LayoutDescriptor.ConstraintValue,
    height: LayoutDescriptor.ConstraintValue
  ) -> Self {
    return self.width(width).height(height)
  }

  /**
   Adding width and height constraint by size with common priority.
   Relations are fixed as `exact`
   */
  public func size(_ size: CGSize, priority: UILayoutPriority = .required) -> Self {
    _modify {
      $0.height = .init(constant: size.height, priority: priority)
      $0.width = .init(constant: size.width, priority: priority)
    }
  }

  /**
   Adding width and height constraint by length with common priority.
   */
  public func size(_ length: CGFloat, priority: UILayoutPriority = .required) -> Self {
    _modify {
      $0.height = .init(constant: length, priority: priority)
      $0.width = .init(constant: length, priority: priority)
    }
  }
}
