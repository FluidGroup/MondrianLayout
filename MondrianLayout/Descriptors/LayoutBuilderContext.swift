import UIKit

/**
 A building layout enviroment
 - constraints
 - layout guides
 - tasks apply to view (setting content hugging and compression resistance)
 */
public final class LayoutBuilderContext {

  public weak var targetView: UIView?
  public let name: String?
  public private(set) var isActive = false

  public init(
    name: String? = nil,
    targetView: UIView
  ) {
    self.name = name
    self.targetView = targetView
  }

  public private(set) var managedLayoutGuides: [UILayoutGuide] = []
  public private(set) var constraints: [NSLayoutConstraint] = []
  public private(set) var viewBlocks: [ViewBlock] = []
  public private(set) var unmanagedLayoutGuides: [LayoutGuideBlock] = []
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

    managedLayoutGuides.append(guide)
    return guide
  }

  func register(viewBlock: ViewBlock) {
    assert(viewBlocks.contains(where: { $0.view == viewBlock.view }) == false)

    viewBlocks.append(viewBlock)
    constraints.append(contentsOf: viewBlock.makeConstraints())
    viewAppliers.append(viewBlock.makeApplier())
  }

  func register(layoutGuideBlock: LayoutGuideBlock) {
    unmanagedLayoutGuides.append(layoutGuideBlock)
    constraints.append(contentsOf: layoutGuideBlock.makeConstraints())
  }

  /// Add including views to the target view.
  public func prepareViewHierarchy() {

    guard let targetView = targetView else {
      return
    }

    viewBlocks.forEach {
      $0.view.translatesAutoresizingMaskIntoConstraints = false
      targetView.addSubview($0.view)
    }
  }

  /**
   Activate constraints and layout guides.
   */
  public func activate() {

    assert(Thread.isMainThread)

    guard let targetView = targetView else {
      return
    }

    guard isActive == false else {
      return
    }

    isActive = true

    viewAppliers.forEach { $0() }

    managedLayoutGuides.forEach {
      targetView.addLayoutGuide($0)
    }

    unmanagedLayoutGuides.forEach {
      targetView.addLayoutGuide($0.layoutGuide)
    }

    NSLayoutConstraint.activate(constraints)

  }

  /**
   Deactivate constraints and layout guides.
   */
  public func deactivate() {

    guard let targetView = targetView else {
      return
    }

    guard isActive == true else {
      return
    }

    isActive = false

    managedLayoutGuides.forEach {
      targetView.removeLayoutGuide($0)
    }

    unmanagedLayoutGuides.forEach {
      targetView.removeLayoutGuide($0.layoutGuide)
    }

    NSLayoutConstraint.deactivate(constraints)
  }

}

