import UIKit

@discardableResult
public func mondrianBatchLayout(@MondrianArrayBuilder<LayoutDescriptor> _ closure: () -> [LayoutDescriptor]) -> ConstraintGroup {

  let descriptors = closure()

  let group = ConstraintGroup(constraints: [])

  descriptors.forEach {
    let g = $0.activate()
    group.append(g)
  }

  return group

}

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

  public func activate() {

    NSLayoutConstraint.activate(constraints)
  }

  public func deactivate() {

    NSLayoutConstraint.deactivate(constraints)
  }

}

/**
 A representation of how sets the constraints from the target element (UIView or UILayoutGuide).
 */
public struct LayoutDescriptor: _DimensionConstraintType {

  public struct ConstraintValue {

    public enum Condition {
      case min
      case constant
      case max
    }

    public var condition: Condition
    public var value: CGFloat
    public var priority: UILayoutPriority

    public init(
      condition: Condition,
      value: CGFloat,
      priority: UILayoutPriority
    ) {
      self.condition = condition
      self.value = value
      self.priority = priority
    }

    public static func min(_ value: CGFloat, _ priority: UILayoutPriority = .required) -> Self {
      return .init(condition: .min, value: value, priority: priority)
    }

    public static func constant(_ value: CGFloat, _ priority: UILayoutPriority = .required) -> Self
    {
      return .init(condition: .constant, value: value, priority: priority)
    }

    public static func max(_ value: CGFloat, _ priority: UILayoutPriority = .required) -> Self {
      return .init(condition: .max, value: value, priority: priority)
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

  private func takeParentLayoutElementWithAssertion() -> _LayoutElement? {
    assert(target.owningView != nil, "\(target.view ?? target.layoutGuide as Any) must have parent view.") 
    return target.owningView.map { .init(view: $0) }
  }

  private var constraints: [NSLayoutConstraint] = []

  private func _modify(_ modifier: (inout Self) -> Void) -> Self {
    var new = self
    modifier(&new)
    return new
  }

  @discardableResult
  private mutating func makeConstraint(
    to element: __LayoutElementConvertible,
    _ closure: (_LayoutElement, _LayoutElement) -> NSLayoutConstraint
  ) -> NSLayoutConstraint {
    let constraint = closure(target, element._layoutElement)
    constraints.append(constraint)
    return constraint
  }

  // MARK: X axis

  private func _anchor(
    _ from: _LayoutElement.XAxisAnchor,
    to element: __LayoutElementConvertible,
    _ target: _LayoutElement.XAxisAnchor,
    _ condition: ConstraintValue
  ) -> Self {
    return _modify {
      $0.makeConstraint(to: element) {
        $0.anchor(from).constraint(value: condition, to: $1.anchor(target))
      }
    }
  }

  private func _anchor(
    _ from: _LayoutElement.YAxisAnchor,
    to element: __LayoutElementConvertible,
    _ target: _LayoutElement.YAxisAnchor,
    _ condition: ConstraintValue
  ) -> Self {
    return _modify {
      $0.makeConstraint(to: element) {
        $0.anchor(from).constraint(value: condition, to: $1.anchor(target))
      }
    }
  }

  public func leading(
    to element: __LayoutElementConvertible,
    _ target: _LayoutElement.XAxisAnchor = .leading,
    _ condition: ConstraintValue = .constant(0)
  ) -> Self {
    _anchor(.leading, to: element, target, condition)
  }

  public func trailing(
    to element: __LayoutElementConvertible,
    _ target: _LayoutElement.XAxisAnchor = .trailing,
    _ condition: ConstraintValue = .constant(0)
  ) -> Self {
    _anchor(.trailing, to: element, target, condition)
  }

  public func left(
    to element: __LayoutElementConvertible,
    _ target: _LayoutElement.XAxisAnchor = .left,
    _ condition: ConstraintValue = .constant(0)
  ) -> Self {
    _anchor(.left, to: element, target, condition)
  }

  public func right(
    to element: __LayoutElementConvertible,
    _ target: _LayoutElement.XAxisAnchor = .right,
    _ condition: ConstraintValue = .constant(0)
  ) -> Self {
    _anchor(.right, to: element, target, condition)
  }

  public func centerX(
    to element: __LayoutElementConvertible,
    _ target: _LayoutElement.XAxisAnchor = .centerX,
    _ condition: ConstraintValue = .constant(0)
  ) -> Self {
    _anchor(.centerX, to: element, target, condition)
  }

  public func leadingToSuperview(
    _ target: _LayoutElement.XAxisAnchor = .leading,
    _ condition: ConstraintValue = .constant(0)
  ) -> Self {
    guard let parent = takeParentLayoutElementWithAssertion() else { return self }
    return _anchor(.leading, to: parent, target, condition)
  }

  public func trailingToSuperview(
    _ target: _LayoutElement.XAxisAnchor = .trailing,
    _ condition: ConstraintValue = .constant(0)
  ) -> Self {
    guard let parent = takeParentLayoutElementWithAssertion() else { return self }
    return _anchor(.trailing, to: parent, target, condition)
  }

  public func leftToSuperview(
    _ target: _LayoutElement.XAxisAnchor = .left,
    _ condition: ConstraintValue = .constant(0)
  ) -> Self {
    guard let parent = takeParentLayoutElementWithAssertion() else { return self }
    return _anchor(.left, to: parent, target, condition)
  }

  public func rightToSuperview(
    _ target: _LayoutElement.XAxisAnchor = .right,
    _ condition: ConstraintValue = .constant(0)
  ) -> Self {
    guard let parent = takeParentLayoutElementWithAssertion() else { return self }
    return _anchor(.right, to: parent, target, condition)
  }

  public func centerXToSuperview(
    _ target: _LayoutElement.XAxisAnchor = .centerX,
    _ condition: ConstraintValue = .constant(0)
  ) -> Self {
    guard let parent = takeParentLayoutElementWithAssertion() else { return self }
    return _anchor(.centerX, to: parent, target, condition)
  }

  // MARK: Y axis

  public func top(
    to element: __LayoutElementConvertible,
    _ target: _LayoutElement.YAxisAnchor = .top,
    _ condition: ConstraintValue = .constant(0)
  ) -> Self {
    _anchor(.top, to: element, target, condition)
  }

  public func bottom(
    to element: __LayoutElementConvertible,
    _ target: _LayoutElement.YAxisAnchor = .bottom,
    _ condition: ConstraintValue = .constant(0)
  ) -> Self {
    _anchor(.bottom, to: element, target, condition)
  }

  public func centerY(
    to element: __LayoutElementConvertible,
    _ target: _LayoutElement.YAxisAnchor = .centerY,
    _ condition: ConstraintValue = .constant(0)
  ) -> Self {
    _anchor(.centerY, to: element, target, condition)
  }

  public func topToSuperview(
    _ target: _LayoutElement.YAxisAnchor = .top,
    _ condition: ConstraintValue = .constant(0)
  ) -> Self {
    guard let parent = takeParentLayoutElementWithAssertion() else { return self }
    return _anchor(.top, to: parent, target, condition)
  }

  public func bottomToSuperview(
    _ target: _LayoutElement.YAxisAnchor = .bottom,
    _ condition: ConstraintValue = .constant(0)
  ) -> Self {
    guard let parent = takeParentLayoutElementWithAssertion() else { return self }
    return _anchor(.bottom, to: parent, target, condition)
  }

  public func centerYToSuperView(
    _ target: _LayoutElement.YAxisAnchor = .centerY,
    _ condition: ConstraintValue = .constant(0)
  ) -> Self {
    guard let parent = takeParentLayoutElementWithAssertion() else { return self }
    return _anchor(.centerY, to: parent, target, condition)
  }

  /**
   Activates layout constraints
   */
  @discardableResult
  public func activate() -> ConstraintGroup {

    let _dimensionConstraints = dimensionConstraints.makeConstraints(for: target)

    target.view?.translatesAutoresizingMaskIntoConstraints = false

    let group = ConstraintGroup(constraints: constraints + _dimensionConstraints)
    group.activate()
    return group

  }

}

extension NSLayoutXAxisAnchor {

  fileprivate func constraint(
    value: LayoutDescriptor.ConstraintValue,
    to anchor: NSLayoutXAxisAnchor
  ) -> NSLayoutConstraint {

    switch value.condition {
    case .min:
      return constraint(greaterThanOrEqualTo: anchor, constant: value.value).withPriority(
        value.priority
      )
    case .constant:
      return constraint(equalTo: anchor, constant: value.value).withPriority(value.priority)
    case .max:
      return constraint(lessThanOrEqualTo: anchor, constant: value.value).withPriority(
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

    switch value.condition {
    case .min:
      return constraint(greaterThanOrEqualTo: anchor, constant: value.value).withPriority(
        value.priority
      )
    case .constant:
      return constraint(equalTo: anchor, constant: value.value).withPriority(value.priority)
    case .max:
      return constraint(lessThanOrEqualTo: anchor, constant: value.value).withPriority(
        value.priority
      )
    }

  }
}

extension MondrianNamespace where Base : UIView {

  public var layout: LayoutDescriptor {
    .init(view: base)
  }

}

extension MondrianNamespace where Base : UILayoutGuide {

  public var layout: LayoutDescriptor {
    .init(layoutGuide: base)
  }

}
