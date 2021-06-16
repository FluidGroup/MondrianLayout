import UIKit

extension UIView {

  /**
   Applies the layout constraints
   Adding subviews included in layout
   */
  @discardableResult
  public func buildSublayersLayout<Descriptor: LayoutDescriptorType>(build: () -> Descriptor) -> LayoutBuilderContext {

    let context = LayoutBuilderContext(targetView: self)
    let layout = build()
    layout.setupConstraints(parent: .init(view: self), in: context)

    context.prepareViewHierarchy()
    context.activate()

    return context
  }

  @discardableResult
  public func buildSublayersLayout(build: () -> SafeAreaConstraint) -> LayoutBuilderContext {

    let context = LayoutBuilderContext(targetView: self)
    let layout = build()
    layout.setupConstraints(parent: self, in: context)

    context.prepareViewHierarchy()
    context.activate()

    return context
  }

  public func buildSelfSizing(build: (ViewConstraint) -> ViewConstraint) {

    let constraint = ViewConstraint(self)
    let modifiedConstraint = build(constraint)

    modifiedConstraint.makeApplier()()
    NSLayoutConstraint.activate(
      modifiedConstraint.makeConstraints()
    )

  }

  public var viewConstraint: ViewConstraint {
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
