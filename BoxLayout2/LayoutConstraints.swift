import UIKit

public struct SingleElement<View: UIView>: ConstraintLayoutElementType {

  private let view: View

  public init(
    view: View
  ) {
    self.view = view
  }
}

public struct MultipleElements: ConstraintLayoutElementType {

  public let components: [ConstraintLayoutElementType]

  public init(
    components: [ConstraintLayoutElementType]
  ) {
    self.components = components
  }

}

public final class Context {

  private let targetView: UIView

  public init(
    targetView: UIView
  ) {
    self.targetView = targetView
  }

  public private(set) var layoutGuides: [UILayoutGuide] = []
  public private(set) var constraints: [NSLayoutConstraint] = []
  public private(set) var views: [ViewConstraint] = []

  func add(constraints: [NSLayoutConstraint]) {
    self.constraints.append(contentsOf: constraints)
  }

  func makeLayoutGuide() -> UILayoutGuide {

    let guide = UILayoutGuide()

    layoutGuides.append(guide)
    return guide
  }

  func register(view: ViewConstraint) {
    views.append(view)

    constraints.append(contentsOf: view.makeConstraints())
  }

  public func prepareViewHierarchy() {
    views.forEach {
      $0.view.translatesAutoresizingMaskIntoConstraints = false
      targetView.addSubview($0.view)
    }
  }

  public func activate() {

    layoutGuides.forEach {
      targetView.addLayoutGuide($0)
    }

    NSLayoutConstraint.activate(constraints)

  }
}

//public struct ZStackConstraint: ConstraintLayoutElementType {
//
//  public let content: Content
//
//  public init(
//    @LayoutConstraintBuilder content: () -> Content
//  ) {
//    self.content = content()
//  }
//
//}

public struct StackSpacer {

  public let minLength: CGFloat

  public init(
    minLength: CGFloat
  ) {
    self.minLength = minLength
  }
}
