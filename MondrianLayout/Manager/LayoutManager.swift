
import UIKit

/**
 An object that manages layout.
 It supports updating the layout.
 In the case of defining distinct layouts under some conditions, this helps.
 */
public final class LayoutManager {

  private var _layoutBuilder: (() -> [EntrypointBuilder.Either])?
  private var currentContext: LayoutBuilderContext?
  private weak var targetView: UIView?

  public init() {
  }

  /**
   Setting up the layout of subviews on the view.
   the layout closure is called each calling `reloadLayout` and after `setup`.

   Please avoid creating view and layout-guide instances in the closure. Performance decreases by creating a new instance and destroying the previous one.
   */
  public func setup(
    on view: UIView,
    @EntrypointBuilder layout: @escaping () -> [EntrypointBuilder.Either]
  ) {
    targetView = view
    _layoutBuilder = layout
    reloadLayout()
  }

  /**
   Re lays out the subviews with deactivating the current layout.
   */
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
