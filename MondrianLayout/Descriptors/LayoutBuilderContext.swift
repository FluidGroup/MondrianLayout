import UIKit

/**
 A building layout enviroment
 - constraints
 - layout guides
 - tasks apply to view (setting content hugging and compression resistance)
 */
public final class LayoutBuilderContext {

  public let targetView: UIView
  public let name: String?

  public init(
    name: String? = nil,
    targetView: UIView
  ) {
    self.name = name
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
    if let name = name {
      guide.identifier = "\(identifier):\(name)"
    } else {
      guide.identifier = identifier
    }

    layoutGuides.append(guide)
    return guide
  }

  func register(view: ViewConstraint) {
    views.append(view)
    constraints.append(contentsOf: view.makeConstraints())
    viewAppliers.append(view.makeApplier())
  }

  /// Add including views to the target view.
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

