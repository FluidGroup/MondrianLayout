import UIKit

extension UIView {

  /**
   Applies the layout constraints
   Adding subviews included in layout
   */
  @discardableResult
  public func buildSublayersLayout<Descriptor: LayoutDescriptorType>(build: () -> Descriptor) -> Context {

    let context = Context(targetView: self)
    let layout = build()
    layout.setupConstraints(parent: .init(view: self), in: context)

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

  public func viewConstraint() -> ViewConstraint {
    .init(self)
  }

}
