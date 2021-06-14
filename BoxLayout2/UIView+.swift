import UIKit

extension UIView {

  @discardableResult
  public func buildLayout(build: () -> VStackConstraint) -> Context {

    let context = Context(targetView: self)
    let layout = build()
    layout.setupConstraints(parent: .init(view: self), in: context)

    context.prepareViewHierarchy()
    context.activate()

    return context
  }

  public func viewConstraint() -> ViewConstraint {
    .init(self)
  }

}
