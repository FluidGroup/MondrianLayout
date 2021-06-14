import UIKit

public struct VStackConstraint: LayoutDescriptorType, _RelativeContentConvertible {

  public var _relativeContent: _RelativeContent {
    .vStack(self)
  }

  public let elements: [_VHStackContent]

  public init(
    @VHStackContentBuilder elements: () -> [_VHStackContent]
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
      case .view(let viewConstraint):

        let view = viewConstraint.view

        context.register(view: viewConstraint)

        context.add(constraints: [
          view.topAnchor.constraint(equalTo: parent.topAnchor),
          view.leftAnchor.constraint(equalTo: parent.leftAnchor),
          view.rightAnchor.constraint(equalTo: parent.rightAnchor),
          view.bottomAnchor.constraint(equalTo: parent.bottomAnchor),
        ])

      case .relative(let relativeConstraint):

        relativeConstraint.setupConstraints(parent: parent, in: context)

      case .vStack(let stackConstraint):

        stackConstraint.setupConstraints(parent: parent, in: context)

      case .hStack(let stackConstraint):

        stackConstraint.setupConstraints(parent: parent, in: context)

      case .zStack(let stackConstraint):

        stackConstraint.setupConstraints(parent: parent, in: context)

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
            currentBox.leftAnchor.constraint(equalTo: parent.leftAnchor),
            currentBox.rightAnchor.constraint(equalTo: parent.rightAnchor),
          ])

          if let previous = previous {

            if elements.indices.last == i {
              // last element
              context.add(constraints: [
                currentBox.topAnchor.constraint(
                  equalTo: previous.bottomAnchor,
                  constant: spaceToPrevious
                ),
                currentBox.bottomAnchor.constraint(equalTo: parent.bottomAnchor),
              ])
            } else {
              // middle element
              context.add(constraints: [
                currentBox.topAnchor.constraint(
                  equalTo: previous.bottomAnchor,
                  constant: spaceToPrevious
                )
              ])
            }
          } else {
            // first element
            context.add(constraints: [
              currentBox.topAnchor.constraint(
                equalTo: parent.topAnchor,
                constant: initialSpace
              )
            ])
          }

          spaceToPrevious = 0
        }

        switch element {
        case .view(let viewConstraint):

          let view = viewConstraint.view
          currentBox = .init(view: view)
          context.register(view: viewConstraint)
          perform()
          previous = currentBox

        case .relative(let relativeConstraint):

          let newLayoutGuide = context.makeLayoutGuide(identifier: "VStackConstraint.Relative")
          currentBox = .init(layoutGuide: newLayoutGuide)
          relativeConstraint.setupConstraints(parent: currentBox, in: context)
          perform()
          previous = currentBox

        case .vStack(let stackConstraint):

          let newLayoutGuide = context.makeLayoutGuide(identifier: "VStackConstraint.VStack")
          currentBox = .init(layoutGuide: newLayoutGuide)
          stackConstraint.setupConstraints(parent: currentBox, in: context)
          perform()
          previous = currentBox

        case .hStack(let stackConstraint):

          let newLayoutGuide = context.makeLayoutGuide(identifier: "VStackConstraint.HStack")
          currentBox = .init(layoutGuide: newLayoutGuide)
          stackConstraint.setupConstraints(parent: currentBox, in: context)
          perform()
          previous = currentBox

        case .zStack(let stackConstraint):

          let newLayoutGuide = context.makeLayoutGuide(identifier: "VStackConstraint.ZStack")
          currentBox = .init(layoutGuide: newLayoutGuide)
          stackConstraint.setupConstraints(parent: currentBox, in: context)
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
