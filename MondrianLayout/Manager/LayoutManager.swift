
import UIKit

public final class LayoutManager {

  private var _layoutBuilder: (() -> [EntrypointBuilder.Either])?
  private var currentContext: LayoutBuilderContext?
  private weak var targetView: UIView?

  public init(initialContext: LayoutBuilderContext? = nil) {
    self.currentContext = initialContext
  }

  public func setup(
    on view: UIView,
    @EntrypointBuilder layout: @escaping () -> [EntrypointBuilder.Either]
  ) {
    targetView = view
    _layoutBuilder = layout
    reloadLayout()
  }

  public func reloadLayout() {
    guard let _layoutBuilder = _layoutBuilder else {
      return
    }

    guard let targetView = targetView else {
      return
    }

    let previousContext = currentContext

    previousContext?.deactivate()
    let newContext = targetView.mondrian.buildSubviews(_layoutBuilder)
    currentContext = newContext

  }

}
