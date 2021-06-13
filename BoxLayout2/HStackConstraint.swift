import UIKit

public struct HStackConstraint: ConstraintLayoutElementType {

  public let elements: [VHStackElement]

  public init(
    @StackElementBuilder elements: () -> [VHStackElement]
  ) {
    self.elements = elements()
  }

  public func setupConstraints(parent: LayoutBox, in context: Context) {

    let parsed = elements

    guard parsed.isEmpty == false else {
      return
    }

    if parsed.count == 1 {

      let first = parsed.first!

      switch first {
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
      case .spacer:
        // FIXME:
        break
      }

    } else {

      var hasStartedLayout = false
      var initialSpace: CGFloat = 0
      var previous: LayoutBox?
      var spaceToPrevious: CGFloat = 0
      var currentBox: LayoutBox!

      for (i, element) in parsed.enumerated() {

        func perform() {

          hasStartedLayout = true

          context.add(constraints: [
            currentBox.topAnchor.constraint(equalTo: parent.topAnchor),
            currentBox.bottomAnchor.constraint(equalTo: parent.bottomAnchor),
          ])

          if let previous = previous {

            if elements.indices.last == i {
              // last element
              context.add(constraints: [
                currentBox.leftAnchor.constraint(equalTo: previous.rightAnchor, constant: spaceToPrevious),
                currentBox.rightAnchor.constraint(equalTo: parent.rightAnchor),
              ])
            } else {
              // middle element
              context.add(constraints: [
                currentBox.leftAnchor.constraint(equalTo: previous.rightAnchor, constant: spaceToPrevious)
              ])
            }
          } else {
            // first element
            context.add(constraints: [
              currentBox.leftAnchor.constraint(
                equalTo: parent.leftAnchor,
                constant: initialSpace
              )
            ])
          }

          spaceToPrevious = 0
        }

        switch element {
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

        case .spacer(let spacer):

          if hasStartedLayout == false {
            initialSpace += spacer.minLength
          } else {
            spaceToPrevious += spacer.minLength
          }

        }

      }

    }

  }

}
