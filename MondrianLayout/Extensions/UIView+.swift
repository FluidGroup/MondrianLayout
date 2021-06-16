import UIKit

extension UIView {

  /**
   Applies the layout constraints
   Adding subviews included in layout
   */
  @discardableResult
  public func buildSublayersLayout(
    safeArea: Edge.Set = [],
    @SafeAreaContentBuilder build: () -> _SafeAreaContent
  ) -> LayoutBuilderContext {

    let context = LayoutBuilderContext(targetView: self)
    let container = SafeAreaContainer(edge: safeArea) {
      build()
    }
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
