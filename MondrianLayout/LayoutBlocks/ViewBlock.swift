import UIKit

public struct AxisMask: OptionSet {

  public var rawValue: Int8
  public var isEmpty: Bool {
    rawValue == 0
  }

  public init(rawValue: Int8) {
    self.rawValue = rawValue
  }

  public static let vertical: Self = .init(rawValue: 1 << 1)
  public static let horizontal: Self = .init(rawValue: 1 << 2)
}

public struct ViewBlock: _LayoutBlockNodeConvertible, _DimensionConstraintType,
  Equatable
{

  public var _layoutBlockNode: _LayoutBlockNode {
    return .view(self)
  }

  public let view: UIView

  public var dimensionConstraints: DimensionDescriptor = .init()

  var verticalHuggingPriority: UILayoutPriority?
  var horizontalHuggingPriority: UILayoutPriority?

  var verticalCompressionResistancePriority: UILayoutPriority?
  var horizontalCompressionResistancePriority: UILayoutPriority?

  public init(
    _ view: UIView
  ) {
    self.view = view
  }

  private func _modify(_ modifier: (inout Self) -> Void) -> Self {
    var new = self
    modifier(&new)
    return new
  }

  public func huggingPriority(
    _ axisMask: AxisMask,
    _ priority: UILayoutPriority = .required
  ) -> Self {
    _modify {
      if axisMask.contains(.horizontal) {
        $0.horizontalHuggingPriority = priority
      }
      if axisMask.contains(.vertical) {
        $0.verticalHuggingPriority = priority
      }
    }
  }

  public func compressionResistancePriority(
    _ axisMask: AxisMask,
    _ priority: UILayoutPriority = .required
  ) -> Self {
    _modify {
      if axisMask.contains(.horizontal) {
        $0.horizontalCompressionResistancePriority = priority
      }
      if axisMask.contains(.vertical) {
        $0.verticalCompressionResistancePriority = priority
      }
    }
  }

  func makeConstraintsToEdge(_ element: _LayoutElement) -> [NSLayoutConstraint] {
    return
      [
        view.topAnchor.constraint(equalTo: element.topAnchor),
        view.leadingAnchor.constraint(equalTo: element.leadingAnchor),
        view.bottomAnchor.constraint(equalTo: element.bottomAnchor),
        view.trailingAnchor.constraint(equalTo: element.trailingAnchor),
    ]

  }

  func makeApplier() -> () -> Void {

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
        view.setContentCompressionResistancePriority(priority, for: .horizontal)
      }
    }
  }

  func makeConstraints() -> [NSLayoutConstraint] {
    dimensionConstraints.makeConstraints(for: view)
  }

}
