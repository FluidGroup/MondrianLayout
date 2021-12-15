import UIKit

@available(*, deprecated, renamed: "Mondrian.layout")
@discardableResult
public func mondrianBatchLayout(
  @MondrianArrayBuilder<LayoutDescriptor> _ closure: () -> [LayoutDescriptor]
) -> ConstraintGroup {
  Mondrian.layout(closure)
}

/**
 A group that manages constraints.
 */
public final class ConstraintGroup {

  public private(set) var constraints: [NSLayoutConstraint]

  public init(
    constraints: [NSLayoutConstraint]
  ) {
    self.constraints = constraints
  }

  public func append(_ constraint: NSLayoutConstraint) {
    self.constraints.append(constraint)
  }

  public func append(_ otherGroup: ConstraintGroup) {
    self.constraints.append(contentsOf: otherGroup.constraints)
  }

  /**
   Activates the all of constraints managed in this group.
   */
  public func activate() {

    NSLayoutConstraint.activate(constraints)
  }

  /**
   Deactivates the all of constraints managed in this group.
   */
  public func deactivate() {

    NSLayoutConstraint.deactivate(constraints)
  }

}

public enum LayoutDescriptorElementTraitEdgeAttaching {}
public enum LayoutDescriptorElementTraitCenterPositioning {}
public enum LayoutDescriptorElementTraitSizing {}

public struct LayoutDescriptorElement<Trait> {

  let usesSuperview: Bool
  let layoutElement: _LayoutElement?

  var anchorXAxis: _LayoutElement.XAxisAnchor?
  var anchorYAxis: _LayoutElement.YAxisAnchor?

  var dimension: _LayoutElement.DimensionAnchor?

  public static func to(_ element: _LayoutElement) -> LayoutDescriptorElement {
    return .init(usesSuperview: false, layoutElement: element)
  }

  public static func to(_ view: UIView) -> LayoutDescriptorElement {
    return .init(usesSuperview: false, layoutElement: .init(view: view))
  }

  public static func to(_ layoutGuide: UILayoutGuide) -> LayoutDescriptorElement {
    return .init(usesSuperview: false, layoutElement: .init(layoutGuide: layoutGuide))
  }

  public static var toSuperview: LayoutDescriptorElement {
    return .init(usesSuperview: true, layoutElement: nil)
  }

}

extension LayoutDescriptorElement where Trait == LayoutDescriptorElementTraitCenterPositioning {

  public func positioned(x: _LayoutElement.XAxisAnchor, y: _LayoutElement.YAxisAnchor) -> Self {
    modified(self) {
      $0.anchorXAxis = x
      $0.anchorYAxis = y
    }
  }

}

extension LayoutDescriptorElement where Trait == LayoutDescriptorElementTraitSizing {

  public var width: Self {
    modified(self) {
      $0.dimension = .width
    }
  }

  public var height: Self {
    modified(self) {
      $0.dimension = .height
    }
  }

}

extension LayoutDescriptorElement where Trait == _LayoutElement.XAxisAnchor {
  public var left: Self {
    modified(self) {
      $0.anchorXAxis = .left
    }
  }

  public var right: Self {
    modified(self) {
      $0.anchorXAxis = .right
    }
  }

  public var centerX: Self {
    modified(self) {
      $0.anchorXAxis = .centerX
    }
  }

  public var leading: Self {
    modified(self) {
      $0.anchorXAxis = .leading
    }
  }

  public var trailing: Self {
    modified(self) {
      $0.anchorXAxis = .trailing
    }
  }
}

extension LayoutDescriptorElement where Trait == _LayoutElement.YAxisAnchor {
  public var top: Self {
    modified(self) {
      $0.anchorYAxis = .top
    }
  }

  public var bottom: Self {
    modified(self) {
      $0.anchorYAxis = .bottom
    }
  }

  public var centerY: Self {
    modified(self) {
      $0.anchorYAxis = .centerY
    }
  }
}

/// A representation of how sets the constraints from the target element (UIView or UILayoutGuide).
public struct LayoutDescriptor: _DimensionConstraintType {

  /**
   A constraint representation that projects as `NSLayoutConstraint`.
   */
  public struct ConstraintValue: ExpressibleByFloatLiteral, ExpressibleByIntegerLiteral {

    public typealias IntegerLiteralType = Int
    public typealias FloatLiteralType = Double

    public enum Relation {
      /// greater than or equal
      case min
      /// equal
      case exact
      /// less than or equal
      case max
    }

    public var relation: Relation
    public var constant: CGFloat
    public var priority: UILayoutPriority

    public init(integerLiteral value: Int) {
      self.init(relation: .exact, constant: CGFloat(value), priority: .required)
    }

    public init(floatLiteral value: FloatLiteralType) {
      self.init(relation: .exact, constant: CGFloat(value), priority: .required)
    }

    public init(
      relation: Relation,
      constant: CGFloat,
      priority: UILayoutPriority
    ) {
      self.relation = relation
      self.constant = constant
      self.priority = priority
    }

    /// greater than or equal
    public static func min(_ value: CGFloat, _ priority: UILayoutPriority = .required) -> Self {
      return .init(relation: .min, constant: value, priority: priority)
    }

    /// equal
    public static func exact(_ value: CGFloat, _ priority: UILayoutPriority = .required) -> Self
    {
      return .init(relation: .exact, constant: value, priority: priority)
    }

    /// less than or equal
    public static func max(_ value: CGFloat, _ priority: UILayoutPriority = .required) -> Self {
      return .init(relation: .max, constant: value, priority: priority)
    }
  }

  private let target: _LayoutElement

  /// Creates an instance from `UIView`.
  public init(
    view: UIView
  ) {
    self.target = .init(view: view)
  }

  /// Creates an instance from `UILayoutGuide`.
  public init(
    layoutGuide: UILayoutGuide
  ) {
    self.target = .init(layoutGuide: layoutGuide)
  }

  public var dimensionConstraints: DimensionDescriptor = .init()

  @inline(__always)
  private func takeParentLayoutElementWithAssertion() -> _LayoutElement? {
    assert(
      target.owningView != nil,
      "\(target.view ?? target.layoutGuide as Any) must have parent view."
    )
    return target.owningView.map { .init(view: $0) }
  }

  @inline(__always)
  private func takeLayoutElement<T>(_ element: LayoutDescriptorElement<T>) -> _LayoutElement? {

    guard element.usesSuperview == false else {
      return takeParentLayoutElementWithAssertion()
    }

    return element.layoutElement
  }

  private var proposedConstraints: [NSLayoutConstraint] = []

  @inline(__always)
  private func _modify(_ modifier: (inout Self) -> Void) -> Self {
    var new = self
    modifier(&new)
    return new
  }

  @inline(__always)
  @discardableResult
  private mutating func makeConstraint<T>(
    element: LayoutDescriptorElement<T>,
    identifier: String,
    _ closure: (_LayoutElement, _LayoutElement) -> NSLayoutConstraint
  ) -> NSLayoutConstraint? {

    guard let secondItem = takeLayoutElement(element) else {
      return nil
    }

    let constraint = closure(target, secondItem)
    constraint.identifier = identifier
    proposedConstraints.append(constraint)
    return constraint
  }

  @inline(__always)
  @discardableResult
  private mutating func makeConstraints<T>(
    element: LayoutDescriptorElement<T>,
    identifier: String,
    _ closure: (_LayoutElement, _LayoutElement) -> [NSLayoutConstraint]
  ) -> [NSLayoutConstraint]? {

    guard let secondItem = takeLayoutElement(element) else {
      return nil
    }

    let constraints = closure(target, secondItem)
    constraints.forEach {
      $0.identifier = identifier
    }
    self.proposedConstraints.append(contentsOf: constraints)
    return constraints
  }

  // MARK: - X axis

  /// X axis
  @inline(__always)
  private func _anchorXAxis<T>(
    from: _LayoutElement.XAxisAnchor,
    element: LayoutDescriptorElement<T>,
    defaultAnchor anchor: _LayoutElement.XAxisAnchor,
    value: ConstraintValue,
    identifier: String
  ) -> Self {
    return _modify {
      $0.makeConstraint(element: element, identifier: identifier) {
        $0.anchor(from).constraint(value: value, to: $1.anchor(element.anchorXAxis ?? anchor))
      }
    }
  }

  /// X axis
  @inline(__always)
  private func _anchorXAxisInverted<T>(
    from: _LayoutElement.XAxisAnchor,
    element: LayoutDescriptorElement<T>,
    defaultAnchor anchor: _LayoutElement.XAxisAnchor,
    value: ConstraintValue,
    identifier: String
  ) -> Self {
    return _modify {
      $0.makeConstraint(element: element, identifier: identifier) {
        $1.anchor(element.anchorXAxis ?? anchor).constraint(value: value, to: $0.anchor(from))
      }
    }
  }

  /// Y axis
  @inline(__always)
  private func _anchorYAxis<T>(
    from: _LayoutElement.YAxisAnchor,
    element: LayoutDescriptorElement<T>,
    defaultAnchor anchor: _LayoutElement.YAxisAnchor,
    value: ConstraintValue,
    identifier: String
  ) -> Self {
    return _modify {
      $0.makeConstraint(element: element, identifier: identifier) {
        $0.anchor(from).constraint(value: value, to: $1.anchor(element.anchorYAxis ?? anchor))
      }
    }
  }

  /// Y axis
  @inline(__always)
  private func _anchorYAxisInverted<T>(
    from: _LayoutElement.YAxisAnchor,
    element: LayoutDescriptorElement<T>,
    defaultAnchor anchor: _LayoutElement.YAxisAnchor,
    value: ConstraintValue,
    identifier: String
  ) -> Self {
    return _modify {
      $0.makeConstraint(element: element, identifier: identifier) {
        $1.anchor(element.anchorYAxis ?? anchor).constraint(value: value, to: $0.anchor(from))
      }
    }
  }

  /// Describes a single constraint
  ///
  /// As default, attaches to `leading` of the element
  public func leading(
    _ element: LayoutDescriptorElement<_LayoutElement.XAxisAnchor>,
    _ value: ConstraintValue = .exact(0),
    identifier: String = "mondrian.classic.leading"
  ) -> Self {
    _anchorXAxis(from: .leading, element: element, defaultAnchor: .leading, value: value, identifier: identifier)
  }

  /// Describes a single constraint
  ///
  /// As default, attaches to `trailing` of the element
  public func trailing(
    _ element: LayoutDescriptorElement<_LayoutElement.XAxisAnchor>,
    _ value: ConstraintValue = .exact(0),
    identifier: String = "mondrian.classic.trailing"
  ) -> Self {
    _anchorXAxisInverted(from: .trailing, element: element, defaultAnchor: .trailing, value: value, identifier: identifier)
  }

  /// Describes a single constraint
  ///
  /// As default, attaches to `left` of the element
  public func left(
    _ element: LayoutDescriptorElement<_LayoutElement.XAxisAnchor>,
    _ value: ConstraintValue = .exact(0),
    identifier: String = "mondrian.classic.left"
  ) -> Self {
    _anchorXAxis(from: .left, element: element, defaultAnchor: .left, value: value, identifier: identifier)
  }

  /// Describes a single constraint
  ///
  /// As default, attaches to `right` of the element
  public func right(
    _ element: LayoutDescriptorElement<_LayoutElement.XAxisAnchor>,
    _ value: ConstraintValue = .exact(0),
    identifier: String = "mondrian.classic.right"
  ) -> Self {
    _anchorXAxisInverted(from: .right, element: element, defaultAnchor: .right, value: value, identifier: identifier)
  }

  /// Describes a single constraint
  ///
  /// As default, attaches to `centerX` of the element
  public func centerX(
    _ element: LayoutDescriptorElement<_LayoutElement.XAxisAnchor>,
    _ value: ConstraintValue = .exact(0),
    identifier: String = "mondrian.classic.centerX"
  ) -> Self {
    _anchorXAxis(from: .centerX, element: element, defaultAnchor: .centerX, value: value, identifier: identifier)
  }

  // MARK: - Y axis

  /// Describes a single constraint
  ///
  /// As default, attaches to `top` of the element
  public func top(
    _ element: LayoutDescriptorElement<_LayoutElement.YAxisAnchor>,
    _ value: ConstraintValue = .exact(0),
    identifier: String = "mondrian.classic.top"
  ) -> Self {
    _anchorYAxis(from: .top, element: element, defaultAnchor: .top, value: value, identifier: identifier)
  }

  /// Describes a single constraint
  ///
  /// As default, attaches to `bottom` of the element
  public func bottom(
    _ element: LayoutDescriptorElement<_LayoutElement.YAxisAnchor>,
    _ value: ConstraintValue = .exact(0),
    identifier: String = "mondrian.classic.bottom"
  ) -> Self {
    _anchorYAxisInverted(from: .bottom, element: element, defaultAnchor: .bottom, value: value, identifier: identifier)
  }

  /// Describes a single constraint
  ///
  /// As default, attaches to `centerY` of the element
  public func centerY(
    _ element: LayoutDescriptorElement<_LayoutElement.YAxisAnchor>,
    _ value: ConstraintValue = .exact(0),
    identifier: String = "mondrian.classic.centerY"
  ) -> Self {
    _anchorYAxis(from: .centerY, element: element, defaultAnchor: .centerY, value: value, identifier: identifier)
  }

  // MARK: - Sizing

  /// Describes a single constraint
  ///
  /// As default, attaches to `width` of the element.
  public func width(
    _ element: LayoutDescriptorElement<LayoutDescriptorElementTraitSizing>,
    _ value: ConstraintValue = .exact(0),
    multiplier: CGFloat = 1,
    identifier: String = "mondrian.classic.width"
    ) -> Self {
    return _modify {
      $0.makeConstraint(element: element, identifier: identifier) {
        $0.widthAnchor.constraint(
          multiplier: multiplier,
          constrainedConstant: value,
          to: $1.anchor(element.dimension ?? .width)
        )
      }
    }
  }

  /// Describes a single constraint
  ///
  /// As default, attaches to `height` of the element.
  public func height(
    _ element: LayoutDescriptorElement<LayoutDescriptorElementTraitSizing>,
    _ value: ConstraintValue = .exact(0),
    multiplier: CGFloat = 1,
    identifier: String = "mondrian.classic.height"
  ) -> Self {
    return _modify {
      $0.makeConstraint(element: element, identifier: identifier) {
        $0.heightAnchor.constraint(
          multiplier: multiplier,
          constrainedConstant: value,
          to: $1.anchor(element.dimension ?? .height)
        )
      }
    }
  }

  // MARK: - Sugars

  /// Describes multiple constraints
  public func center(
    _ element: LayoutDescriptorElement<LayoutDescriptorElementTraitCenterPositioning>,
    _ value: ConstraintValue = .exact(0),
    identifier: String = "mondrian.classic.center"
  ) -> Self {
    return _modify {
      $0.makeConstraints(
        element: element,
        identifier: identifier,
        {
          [
            $0.anchor(.centerY).constraint(
              value: value,
              to: $1.anchor(element.anchorYAxis ?? .centerY)
            ),
            $0.anchor(.centerX).constraint(
              value: value,
              to: $1.anchor(element.anchorXAxis ?? .centerX)
            ),
          ]
        }
      )
    }
  }

  /// Describes multiple constraints
  public func edges(
    _ element: LayoutDescriptorElement<LayoutDescriptorElementTraitEdgeAttaching>,
    _ value: ConstraintValue = .exact(0),
    identifier: String = "mondrian.classic.edges"
  ) -> Self {
    return _modify {
      $0.makeConstraints(
        element: element,
        identifier: identifier,
        {
          [
            $0.anchor(.top).constraint(value: value, to: $1.topAnchor),
            $1.anchor(.bottom).constraint(value: value, to: $0.bottomAnchor),
            $0.anchor(.left).constraint(value: value, to: $1.leftAnchor),
            $1.anchor(.right).constraint(value: value, to: $0.rightAnchor),
          ]
        }
      )
    }
  }

  /// Describes multiple constraints
  public func horizontal(
    _ element: LayoutDescriptorElement<LayoutDescriptorElementTraitEdgeAttaching>,
    _ value: ConstraintValue = .exact(0),
    identifier: String = "mondrian.classic.horizontal"
  ) -> Self {
    return _modify {
      $0.makeConstraints(
        element: element,
        identifier: identifier,
        {
          [
            $0.anchor(.left).constraint(value: value, to: $1.leftAnchor),
            $1.anchor(.right).constraint(value: value, to: $0.rightAnchor),
          ]
        }
      )
    }
  }

  /// Describes multiple constraints
  public func vertical(
    _ element: LayoutDescriptorElement<LayoutDescriptorElementTraitEdgeAttaching>,
    _ value: ConstraintValue = .exact(0),
    identifier: String = "mondrian.classic.vertical"
  ) -> Self {
    return _modify {
      $0.makeConstraints(
        element: element,
        identifier: identifier,
        {
          [
            $0.anchor(.top).constraint(value: value, to: $1.topAnchor),
            $1.anchor(.bottom).constraint(value: value, to: $0.bottomAnchor),
          ]
        }
      )
    }
  }

  /**
   Activates layout constraints
   */
  @discardableResult
  public func activate() -> ConstraintGroup {

    target.view?.translatesAutoresizingMaskIntoConstraints = false
    let group = makeConstraintGroup()
    group.activate()
    return group

  }

  public func makeConstraintGroup() -> ConstraintGroup {
    return ConstraintGroup(constraints: makeConstraints())
  }

  public func makeConstraints() -> [NSLayoutConstraint] {
    let _dimensionConstraints = dimensionConstraints.makeConstraints(for: target)
    return proposedConstraints + _dimensionConstraints
  }

}

extension NSLayoutDimension {

  fileprivate func constraint(
    multiplier: CGFloat,
    constrainedConstant: LayoutDescriptor.ConstraintValue,
    to anchor: NSLayoutDimension
  ) -> NSLayoutConstraint {

    switch constrainedConstant.relation {
    case .min:
      return constraint(
        greaterThanOrEqualTo: anchor,
        multiplier: multiplier,
        constant: constrainedConstant.constant
      )
      .setPriority(constrainedConstant.priority)
    case .exact:
      return constraint(
        equalTo: anchor,
        multiplier: multiplier,
        constant: constrainedConstant.constant
      )
      .setPriority(constrainedConstant.priority)
    case .max:
      return constraint(
        lessThanOrEqualTo: anchor,
        multiplier: multiplier,
        constant: constrainedConstant.constant
      )
      .setPriority(constrainedConstant.priority)
    }

  }

}

extension NSLayoutXAxisAnchor {

  fileprivate func constraint(
    value: LayoutDescriptor.ConstraintValue,
    to anchor: NSLayoutXAxisAnchor
  ) -> NSLayoutConstraint {

    switch value.relation {
    case .min:
      return constraint(greaterThanOrEqualTo: anchor, constant: value.constant).setPriority(
        value.priority
      )
    case .exact:
      return constraint(equalTo: anchor, constant: value.constant).setPriority(value.priority)
    case .max:
      return constraint(lessThanOrEqualTo: anchor, constant: value.constant).setPriority(
        value.priority
      )
    }

  }
}

extension NSLayoutYAxisAnchor {

  fileprivate func constraint(
    value: LayoutDescriptor.ConstraintValue,
    to anchor: NSLayoutYAxisAnchor
  ) -> NSLayoutConstraint {

    switch value.relation {
    case .min:
      return constraint(greaterThanOrEqualTo: anchor, constant: value.constant).setPriority(
        value.priority
      )
    case .exact:
      return constraint(equalTo: anchor, constant: value.constant).setPriority(value.priority)
    case .max:
      return constraint(lessThanOrEqualTo: anchor, constant: value.constant).setPriority(
        value.priority
      )
    }

  }
}
