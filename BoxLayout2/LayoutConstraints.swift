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

public enum VHStackElement {

  case view(UIView)
  case spacer(StackSpacer)
  case vStack(VStackConstraint)
  case hStack(HStackConstraint)
  //  case zStack(ZStackConstraint)
}

extension Array where Element == VHStackElement {

  func parsed() -> [VHStackElementParsed] {

    var firstSpacing: CGFloat?
    var parsed: [VHStackElementParsed] = []

    for element in self {
      switch element {
      case .view(let view):
        parsed.append(.init(edge: .view(view)))
      case .vStack(let stack):
        parsed.append(.init(edge: .vStack(stack)))
      case .hStack(let stack):
        parsed.append(.init(edge: .hStack(stack)))
      case .spacer(let spacer):
        if parsed.isEmpty {
          firstSpacing = spacer.minLength
        } else {
          if let lastIndex = parsed.indices.last {
            parsed[lastIndex].spacingAfter += spacer.minLength
          }
        }
      }
    }

    if parsed.isEmpty == false, let firstSpacing = firstSpacing {
      parsed[0].spacingBefore = firstSpacing
    }

    return parsed
  }
}

struct VHStackElementParsed {

  enum Edge {
    case view(UIView)
    case vStack(VStackConstraint)
    case hStack(HStackConstraint)
  }

  var edge: Edge
  var spacingAfter: CGFloat = 0
  var spacingBefore: CGFloat = 0

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
  public private(set) var views: [UIView] = []

  func add(constraints: [NSLayoutConstraint]) {
    self.constraints.append(contentsOf: constraints)
  }

  func makeLayoutGuide() -> UILayoutGuide {

    let guide = UILayoutGuide()

    layoutGuides.append(guide)
    return guide
  }

  func register(view: UIView) {
    views.append(view)
  }

  public func prepareViewHierarchy() {
    views.forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      targetView.addSubview($0)
    }
  }

  public func activate() {

    layoutGuides.forEach {
      targetView.addLayoutGuide($0)
    }

    NSLayoutConstraint.activate(constraints)

  }
}

public struct VStackConstraint: ConstraintLayoutElementType {

  public let elements: [VHStackElement]

  public init(
    @StackElementBuilder elements: () -> [VHStackElement]
  ) {
    self.elements = elements()
  }

  public func setupConstraints(parent: LayoutBox, in context: Context) {

    let parsed = elements.parsed()

    guard parsed.isEmpty == false else {
      return
    }

    if parsed.count == 1 {

      let first = parsed.first!

      switch first.edge {
      case .view(let view):

        context.register(view: view)

        context.add(constraints: [
          view.topAnchor.constraint(equalTo: parent.topAnchor),
          view.leftAnchor.constraint(equalTo: parent.leftAnchor),
          view.rightAnchor.constraint(equalTo: parent.rightAnchor),
          view.bottomAnchor.constraint(equalTo: parent.bottomAnchor),
        ])

      case .vStack(let stack):

        stack.setupConstraints(parent: parent, in: context)

      case .hStack(let stack):

        stack.setupConstraints(parent: parent, in: context)

      }

    } else {

      var previous: LayoutBox?
      var spacing: CGFloat = 0
      var currentBox: LayoutBox!

      for (i, element) in parsed.enumerated() {

        func perform() {
          context.add(constraints: [
            currentBox.leftAnchor.constraint(equalTo: parent.leftAnchor),
            currentBox.rightAnchor.constraint(equalTo: parent.rightAnchor),
          ])

          if let previous = previous {

            if elements.indices.last == i {
              // last element
              context.add(constraints: [
                currentBox.topAnchor.constraint(equalTo: previous.bottomAnchor, constant: spacing),
                currentBox.bottomAnchor.constraint(equalTo: parent.bottomAnchor),
              ])
            } else {
              // middle element
              context.add(constraints: [
                currentBox.topAnchor.constraint(equalTo: previous.bottomAnchor, constant: spacing)
              ])
            }
          } else {
            // first element
            context.add(constraints: [
              currentBox.topAnchor.constraint(
                equalTo: parent.topAnchor,
                constant: element.spacingBefore
              )
            ])
          }
        }

        switch element.edge {
        case .view(let view):

          currentBox = .init(view: view)

          context.register(view: view)

          perform()

          previous = currentBox

        case .vStack(let stack):

          let newLayoutGuide = context.makeLayoutGuide()

          currentBox = .init(layoutGuide: newLayoutGuide)

          stack.setupConstraints(parent: currentBox, in: context)

          perform()

          previous = currentBox

        case .hStack(let stack):

          let newLayoutGuide = context.makeLayoutGuide()

          currentBox = .init(layoutGuide: newLayoutGuide)

          stack.setupConstraints(parent: currentBox, in: context)

          perform()

          previous = currentBox
        }

        spacing = element.spacingAfter

      }

    }

  }

}

public struct HStackConstraint: ConstraintLayoutElementType {

  public let elements: [VHStackElement]

  public init(
    @StackElementBuilder elements: () -> [VHStackElement]
  ) {
    self.elements = elements()
  }

  public func setupConstraints(parent: LayoutBox, in context: Context) {

    let parsed = elements.parsed()

    guard parsed.isEmpty == false else {
      return
    }

    if parsed.count == 1 {

      let first = parsed.first!

      switch first.edge {
      case .view(let view):

        context.register(view: view)

        context.add(constraints: [
          view.topAnchor.constraint(equalTo: parent.topAnchor),
          view.leftAnchor.constraint(equalTo: parent.leftAnchor),
          view.rightAnchor.constraint(equalTo: parent.rightAnchor),
          view.bottomAnchor.constraint(equalTo: parent.bottomAnchor),
        ])

      case .vStack(let stack):

        stack.setupConstraints(parent: parent, in: context)

      case .hStack(let stack):

        stack.setupConstraints(parent: parent, in: context)

      }

    } else {

      var previous: LayoutBox?
      var spacing: CGFloat = 0
      var currentBox: LayoutBox!

      for (i, element) in parsed.enumerated() {

        func perform() {
          context.add(constraints: [
            currentBox.topAnchor.constraint(equalTo: parent.topAnchor),
            currentBox.bottomAnchor.constraint(equalTo: parent.bottomAnchor),
          ])

          if let previous = previous {

            if elements.indices.last == i {
              // last element
              context.add(constraints: [
                currentBox.leftAnchor.constraint(equalTo: previous.rightAnchor, constant: spacing),
                currentBox.rightAnchor.constraint(equalTo: parent.rightAnchor),
              ])
            } else {
              // middle element
              context.add(constraints: [
                currentBox.leftAnchor.constraint(equalTo: previous.rightAnchor, constant: spacing)
              ])
            }
          } else {
            // first element
            context.add(constraints: [
              currentBox.leftAnchor.constraint(
                equalTo: parent.leftAnchor,
                constant: element.spacingBefore
              )
            ])
          }
        }

        switch element.edge {
        case .view(let view):

          currentBox = .init(view: view)

          context.register(view: view)

          perform()

          previous = currentBox

        case .vStack(let stack):

          let newLayoutGuide = context.makeLayoutGuide()

          currentBox = .init(layoutGuide: newLayoutGuide)

          stack.setupConstraints(parent: currentBox, in: context)

          perform()

          previous = currentBox

        case .hStack(let stack):

          let newLayoutGuide = context.makeLayoutGuide()

          currentBox = .init(layoutGuide: newLayoutGuide)

          stack.setupConstraints(parent: currentBox, in: context)

          perform()

          previous = currentBox
        }

        spacing = element.spacingAfter

      }

    }

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
