import UIKit

@discardableResult
public func mondrianBatchLayout(
  @MondrianArrayBuilder<LayoutDescriptor> _ closure: () -> [LayoutDescriptor]
) -> ConstraintGroup {

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

/// A representation of how sets the constraints from the target element (UIView or UILayoutGuide).
public struct LayoutDescriptor: _DimensionConstraintType {

  public struct Element {

    let usesSuperview: Bool
    let layoutElement: _LayoutElement?

    public static func to(_ view: UIView) -> Element {
      return .init(usesSuperview: false, layoutElement: .init(view: view))
    }

    public static func to(_ layoutGuide: UILayoutGuide) -> Element {
      return .init(usesSuperview: false, layoutElement: .init(layoutGuide: layoutGuide))
    }

    public static var toSuperview: Element {
      return .init(usesSuperview: true, layoutElement: nil)
    }

  }

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

  @inline(__always)
  private func takeParentLayoutElementWithAssertion() -> _LayoutElement? {
    assert(
      target.owningView != nil,
      "\(target.view ?? target.layoutGuide as Any) must have parent view."
    )
    return target.owningView.map { .init(view: $0) }
  }

  @inline(__always)
  private func takeLayoutElement(_ element: Element) -> _LayoutElement? {

    guard element.usesSuperview == false else {
      return takeParentLayoutElementWithAssertion()
    }

    return element.layoutElement
  }

  private var constraints: [NSLayoutConstraint] = []

  @inline(__always)
  private func _modify(_ modifier: (inout Self) -> Void) -> Self {
    var new = self
    modifier(&new)
    return new
  }

  @inline(__always)
  @discardableResult
  private mutating func makeConstraint(
    _ element: Element,
    _ closure: (_LayoutElement, _LayoutElement) -> NSLayoutConstraint
  ) -> NSLayoutConstraint? {

    guard let secondItem = takeLayoutElement(element) else {
      return nil
    }

    let constraint = closure(target, secondItem)
    constraints.append(constraint)
    return constraint
  }

  @inline(__always)
  @discardableResult
  private mutating func makeConstraints(
    _ element: Element,
    _ closure: (_LayoutElement, _LayoutElement) -> [NSLayoutConstraint]
  ) -> [NSLayoutConstraint]? {

    guard let secondItem = takeLayoutElement(element) else {
      return nil
    }

    let constraints = closure(target, secondItem)
    self.constraints.append(contentsOf: constraints)
    return constraints
  }

  // MARK: - X axis

  @inline(__always)
  private func _anchor(
    _ from: _LayoutElement.XAxisAnchor,
    _ element: Element,
    _ anchor: _LayoutElement.XAxisAnchor,
    _ value: ConstraintValue
  ) -> Self {
    return _modify {
      $0.makeConstraint(element) {
        $0.anchor(from).constraint(value: value, to: $1.anchor(anchor))
      }
    }
  }

  @inline(__always)
  private func _anchor(
    _ from: _LayoutElement.YAxisAnchor,
    _ element: Element,
    _ anchor: _LayoutElement.YAxisAnchor,
    _ value: ConstraintValue
  ) -> Self {
    return _modify {
      $0.makeConstraint(element) {
        $0.anchor(from).constraint(value: value, to: $1.anchor(anchor))
      }
    }
  }

  public func leading(
    _ element: Element,
    _ anchor: _LayoutElement.XAxisAnchor = .leading,
    _ value: ConstraintValue = .constant(0)
  ) -> Self {
    _anchor(.leading, element, anchor, value)
  }

  public func trailing(
    _ element: Element,
    _ anchor: _LayoutElement.XAxisAnchor = .trailing,
    _ value: ConstraintValue = .constant(0)
  ) -> Self {
    _anchor(.trailing, element, anchor, value)
  }

  public func left(
    _ element: Element,
    _ anchor: _LayoutElement.XAxisAnchor = .left,
    _ value: ConstraintValue = .constant(0)
  ) -> Self {
    _anchor(.left, element, anchor, value)
  }

  public func right(
    _ element: Element,
    _ anchor: _LayoutElement.XAxisAnchor = .right,
    _ value: ConstraintValue = .constant(0)
  ) -> Self {
    _anchor(.right, element, anchor, value)
  }

  public func centerX(
    _ element: Element,
    _ anchor: _LayoutElement.XAxisAnchor = .centerX,
    _ value: ConstraintValue = .constant(0)
  ) -> Self {
    _anchor(.centerX, element, anchor, value)
  }

  // MARK: - Y axis

  public func top(
    _ element: Element,
    _ anchor: _LayoutElement.YAxisAnchor = .top,
    _ value: ConstraintValue = .constant(0)
  ) -> Self {
    _anchor(.top, element, anchor, value)
  }

  public func bottom(
    _ element: Element,
    _ anchor: _LayoutElement.YAxisAnchor = .bottom,
    _ value: ConstraintValue = .constant(0)
  ) -> Self {
    _anchor(.bottom, element, anchor, value)
  }

  public func centerY(
    _ element: Element,
    _ anchor: _LayoutElement.YAxisAnchor = .centerY,
    _ value: ConstraintValue = .constant(0)
  ) -> Self {
    _anchor(.centerY, element, anchor, value)
  }

  // MARK: - Sugars

  public func center(
    _ element: Element,
    _ anchorX: _LayoutElement.XAxisAnchor = .centerX,
    _ anchorY: _LayoutElement.YAxisAnchor = .centerY,
    _ value: ConstraintValue = .constant(0)
  ) -> Self {
    return _modify {
      $0.makeConstraints(
        element,
        {
          [
            $0.anchor(.centerY).constraint(value: value, to: $1.anchor(anchorY)),
            $0.anchor(.centerX).constraint(value: value, to: $1.anchor(anchorX)),
          ]
        }
      )
    }
  }

  public func edges(
    _ element: Element,
    _ value: ConstraintValue = .constant(0)
  ) -> Self {
    return _modify {
      $0.makeConstraints(
        element,
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

extension MondrianNamespace where Base: UIView {

  /**
   Entry point to describe layout constraints
   Activates by calling `activate()` or using `mondrianBatchLayout`

   ```swift
   view.mondrian.layout
     .top(.toSuperview)
     .left(.toSuperview)
     .right(.to(box2), .left)
     .bottom(.to(box2), .bottom)
     .activate()
   ```
   */
  public var layout: LayoutDescriptor {
    .init(view: base)
  }

}

extension MondrianNamespace where Base: UILayoutGuide {

  /**
   Entry point to describe layout constraints
   Activates by calling `activate()` or using `mondrianBatchLayout`

   ```swift
   view.mondrian.layout
     .top(.toSuperview)
     .left(.toSuperview)
     .right(.to(box2), .left)
     .bottom(.to(box2), .bottom)
     .activate()
   ```
   */
  public var layout: LayoutDescriptor {
    .init(layoutGuide: base)
  }

}
