import UIKit

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

  private let owner: _LayoutElement

  public init(
    view: UIView
  ) {
    self.owner = .init(view: view)
  }

  public init(
    layoutGuide: UILayoutGuide
  ) {
    self.owner = .init(layoutGuide: layoutGuide)
  }

  public var dimensionConstraints: DimensionConstraints = .init()

  private func takeParentLayoutElementWithAssertion() -> _LayoutElement? {
    owner.owningView.map { .init(view: $0) }
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
    let constraint = closure(owner, element._layoutElement)
    constraints.append(constraint)
    return constraint
  }

  // MARK: X axis

  private func _anchor(
    _ from: _LayoutElement.XAxis,
    to element: __LayoutElementConvertible,
    _ target: _LayoutElement.XAxis,
    _ condition: ConstraintValue
  ) -> Self {
    return _modify {
      $0.makeConstraint(to: element) {
        $0.anchor(from).constraint(value: condition, to: $1.anchor(target))
      }
    }
  }

  private func _anchor(
    _ from: _LayoutElement.YAxis,
    to element: __LayoutElementConvertible,
    _ target: _LayoutElement.YAxis,
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
    _ target: _LayoutElement.XAxis = .leading,
    _ condition: ConstraintValue = .constant(0)
  ) -> Self {
    _anchor(.leading, to: element, target, condition)
  }

  public func trailing(
    to element: __LayoutElementConvertible,
    _ target: _LayoutElement.XAxis = .trailing,
    _ condition: ConstraintValue = .constant(0)
  ) -> Self {
    _anchor(.trailing, to: element, target, condition)
  }

  public func left(
    to element: __LayoutElementConvertible,
    _ target: _LayoutElement.XAxis = .left,
    _ condition: ConstraintValue = .constant(0)
  ) -> Self {
    _anchor(.left, to: element, target, condition)
  }

  public func right(
    to element: __LayoutElementConvertible,
    _ target: _LayoutElement.XAxis = .right,
    _ condition: ConstraintValue = .constant(0)
  ) -> Self {
    _anchor(.right, to: element, target, condition)
  }

  public func centerX(
    to element: __LayoutElementConvertible,
    _ target: _LayoutElement.XAxis = .centerX,
    _ condition: ConstraintValue = .constant(0)
  ) -> Self {
    _anchor(.centerX, to: element, target, condition)
  }

  public func leading(_ target: _LayoutElement.XAxis = .leading, _ condition: ConstraintValue = .constant(0)) -> Self {
    guard let parent = takeParentLayoutElementWithAssertion() else { return self }
    return _anchor(.leading, to: parent, target, condition)
  }

  public func trailing(_ target: _LayoutElement.XAxis = .trailing, _ condition: ConstraintValue = .constant(0)) -> Self {
    guard let parent = takeParentLayoutElementWithAssertion() else { return self }
    return _anchor(.trailing, to: parent, target, condition)
  }

  public func left(_ target: _LayoutElement.XAxis = .left, _ condition: ConstraintValue = .constant(0)) -> Self {
    guard let parent = takeParentLayoutElementWithAssertion() else { return self }
    return _anchor(.left, to: parent, target, condition)
  }

  public func right(_ target: _LayoutElement.XAxis = .right, _ condition: ConstraintValue = .constant(0)) -> Self {
    guard let parent = takeParentLayoutElementWithAssertion() else { return self }
    return _anchor(.right, to: parent, target, condition)
  }

  public func centerX(_ target: _LayoutElement.XAxis = .centerX, _ condition: ConstraintValue = .constant(0)) -> Self {
    guard let parent = takeParentLayoutElementWithAssertion() else { return self }
    return _anchor(.centerX, to: parent, target, condition)
  }

  // MARK: Y axis

  public func top(
    to element: __LayoutElementConvertible,
    _ target: _LayoutElement.YAxis = .top,
    _ condition: ConstraintValue = .constant(0)
  ) -> Self {
    _anchor(.top, to: element, target, condition)
  }

  public func bottom(
    to element: __LayoutElementConvertible,
    _ target: _LayoutElement.YAxis = .bottom,
    _ condition: ConstraintValue = .constant(0)
  ) -> Self {
    _anchor(.bottom, to: element, target, condition)
  }

  public func centerY(
    to element: __LayoutElementConvertible,
    _ target: _LayoutElement.YAxis = .centerY,
    _ condition: ConstraintValue = .constant(0)
  ) -> Self {
    _anchor(.centerY, to: element, target, condition)
  }

  public func top(_ target: _LayoutElement.YAxis = .top, _ condition: ConstraintValue = .constant(0)) -> Self {
    guard let parent = takeParentLayoutElementWithAssertion() else { return self }
    return _anchor(.top, to: parent, target, condition)
  }

  public func bottom(_ target: _LayoutElement.YAxis = .bottom, _ condition: ConstraintValue = .constant(0)) -> Self {
    guard let parent = takeParentLayoutElementWithAssertion() else { return self }
    return _anchor(.bottom, to: parent, target, condition)
  }

  public func centerY(_ target: _LayoutElement.YAxis, _ condition: ConstraintValue) -> Self {
    guard let parent = takeParentLayoutElementWithAssertion() else { return self }
    return _anchor(.centerY, to: parent, target, condition)
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

  func constraint(
    value: LayoutDescriptor.ConstraintValue,
    to: NSLayoutYAxisAnchor
  ) -> NSLayoutConstraint {
    constraint(equalTo: to)
  }
}

#if DEBUG

func test() {

  let target = UIView()
  let view = UIView()

  view.layout
    .width(10)
    .top()
    .right()
    .leading()

}

#endif

extension UIView {

  public var layout: LayoutDescriptor {
    .init(view: self)
  }

}

extension UILayoutGuide {

  public var layout: LayoutDescriptor {
    .init(layoutGuide: self)
  }

}
