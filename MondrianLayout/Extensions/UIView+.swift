import UIKit

extension UIView {

  /**
   Applies the layout constraints
   Adding subviews included in layout
   */
  @discardableResult
  public func buildSublayersLayout<Block: _LayoutBlockType>(
    build: () -> Block
  ) -> LayoutBuilderContext {

    let context = LayoutBuilderContext(targetView: self)
    let container = build()
    container.setupConstraints(parent: .init(view: self), in: context)
    context.prepareViewHierarchy()
    context.activate()

    return context
  }

  @discardableResult
  public func buildSublayersLayout<Block: _LayoutBlockNodeConvertible>(
    build: () -> LayoutContainer<Block>
  ) -> LayoutBuilderContext {

    let context = LayoutBuilderContext(targetView: self)
    let container = build()
    container.setupConstraints(parent: self, in: context)
    context.prepareViewHierarchy()
    context.activate()

    return context
  }

  /// Applies the layout of the dimension in itself.
  public func buildSelfSizing(build: (ViewBlock) -> ViewBlock) {

    let constraint = ViewBlock(self)
    let modifiedConstraint = build(constraint)

    modifiedConstraint.makeApplier()()
    NSLayoutConstraint.activate(
      modifiedConstraint.makeConstraints()
    )

  }

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
