import UIKit

@resultBuilder
public enum EntrypointBuilder {

  public enum Either {
    case block(_LayoutBlockType)
    case container(LayoutContainer)
  }

  public static func buildBlock() -> [EntrypointBuilder.Either] {
    return []
  }

  public static func buildBlock(_ components: [Either]...) -> [Either] {
    return components.flatMap { $0 }
  }

  public static func buildExpression<Block: _LayoutBlockType>(_ components: Block...) -> [Either] {
    return components.map { .block($0) }
  }

  public static func buildExpression(_ components: LayoutContainer...) -> [EntrypointBuilder.Either] {
    return components.map { .container($0) }
  }

  public static func buildEither(first component: [EntrypointBuilder.Either]) -> [EntrypointBuilder.Either] {
    return component
  }

  public static func buildEither(second component: [EntrypointBuilder.Either]) -> [EntrypointBuilder.Either] {
    return component
  }

}

extension MondrianNamespace where Base : UIView {

  @available(*, deprecated, message: "Use Mondrian.buildSubviews")
  @discardableResult
  public func buildSubviews(@EntrypointBuilder _ build: () -> [EntrypointBuilder.Either]) -> LayoutBuilderContext {
    Mondrian.buildSubviews(on: base, build)
  }

  @available(*, deprecated, message: "Use classic layout")
  /// Applies the layout of the dimension in itself.
  public func buildSelfSizing(build: (ViewBlock) -> ViewBlock) {

    let constraint = ViewBlock(base)
    let modifiedConstraint = build(constraint)

    modifiedConstraint.makeApplier()()
    NSLayoutConstraint.activate(
      modifiedConstraint.makeConstraints()
    )

  }

}

extension UIView {

  public var mondrian: MondrianNamespace<UIView> {
    return .init(base: self)
  }

}



extension UIView {

  /// Returns an instance of ViewBlock to describe layout.
  public var viewBlock: ViewBlock {
    .init(self)
  }

  public var hasAmbiguousLayoutRecursively: Bool {

    var hasAmbiguous: Bool = false

    func traverse(_ view: UIView) {

      if view.hasAmbiguousLayout {
        hasAmbiguous = true
      }

      for subview in view.subviews {
        traverse(subview)
      }

    }

    traverse(self)

    return hasAmbiguous
  }

}
