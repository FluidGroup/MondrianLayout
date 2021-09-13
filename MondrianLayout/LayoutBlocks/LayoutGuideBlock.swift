import UIKit

public struct LayoutGuideBlock:
  _LayoutBlockNodeConvertible,
  _DimensionConstraintType,
  Equatable
{

  public var _layoutBlockNode: _LayoutBlockNode {
    return .layoutGuide(self)
  }

  public let layoutGuide: UILayoutGuide

  public var dimensionConstraints: DimensionDescriptor = .init()

  public init(
    _ layoutGuide: UILayoutGuide
  ) {
    self.layoutGuide = layoutGuide
  }

  func makeConstraintsToEdge(_ element: _LayoutElement) -> [NSLayoutConstraint] {
    return layoutGuide.mondrian.layout.edges(.to(element)).makeConstraints()
  }

  func makeConstraints() -> [NSLayoutConstraint] {
    dimensionConstraints.makeConstraints(for: layoutGuide)
  }

}
