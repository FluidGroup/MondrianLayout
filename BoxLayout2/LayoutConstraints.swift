import UIKit

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
  public private(set) var viewAppliers: [() -> Void] = []

  func add(constraints: [NSLayoutConstraint]) {
    self.constraints.append(contentsOf: constraints)
  }

  func makeLayoutGuide(identifier: String) -> UILayoutGuide {

    let guide = UILayoutGuide()
    guide.identifier = identifier

    layoutGuides.append(guide)
    return guide
  }

  func register(view: ViewConstraint) {
    views.append(view)
    constraints.append(contentsOf: view.makeConstraints())
    viewAppliers.append(view.makeApplier())
  }

  public func prepareViewHierarchy() {
    views.forEach {
      $0.view.translatesAutoresizingMaskIntoConstraints = false
      targetView.addSubview($0.view)
    }
  }

  public func activate() {

    viewAppliers.forEach { $0() }

    layoutGuides.forEach {
      targetView.addLayoutGuide($0)
    }

    NSLayoutConstraint.activate(constraints)

  }
}

public struct StackSpacer {

  public let minLength: CGFloat

  public init(
    minLength: CGFloat
  ) {
    self.minLength = minLength
  }
}
