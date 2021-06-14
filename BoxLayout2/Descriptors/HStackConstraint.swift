import UIKit

public struct HStackConstraint: LayoutDescriptorType, _RelativeContentConvertible {

  public enum VerticalAlignment {
    case top
    case center
    case bottom
    case fill
  }

  public var _relativeContent: _RelativeContent {
    return .hStack(self)
  }

  public let spacing: CGFloat
  public let alignment: VerticalAlignment
  public let elements: [_VHStackContent]

  public init(
    spacing: CGFloat = 0,
    alignment: VerticalAlignment = .fill,
    @VHStackContentBuilder elements: () -> [_VHStackContent]
  ) {
    self.spacing = spacing
    self.alignment = alignment
    self.elements = elements()
  }

  public func setupConstraints(parent: _LayoutElement, in context: Context) {

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

        // FIXME: case of single element, constraints

        context.add(constraints: [
          view.topAnchor.constraint(equalTo: parent.topAnchor).withInternalIdentifier("HStack.top"),
          view.leftAnchor.constraint(equalTo: parent.leftAnchor).withInternalIdentifier("HStack.left"),
          view.rightAnchor.constraint(equalTo: parent.rightAnchor).withInternalIdentifier("HStack.right"),
          view.bottomAnchor.constraint(equalTo: parent.bottomAnchor).withInternalIdentifier("HStack.bottom"),
        ])

      case .relative(let constraint as LayoutDescriptorType),
           .vStack(let constraint as LayoutDescriptorType),
           .hStack(let constraint as LayoutDescriptorType),
           .zStack(let constraint as LayoutDescriptorType):

        constraint.setupConstraints(parent: parent, in: context)

      case .spacer:
        // FIXME:
        break
      }

    } else {

      var hasStartedLayout = false
      var initialSpace: CGFloat = 0
      var previous: _LayoutElement?
      var spaceToPrevious: CGFloat = 0
      var currentBox: _LayoutElement!

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

          spaceToPrevious = spacing
        }

        switch element {
        case .view(let viewConstraint):

          let view = viewConstraint.view
          currentBox = .init(view: view)
          context.register(view: viewConstraint)
          perform()
          previous = currentBox

        case .relative(let relativeConstraint):

          let newLayoutGuide = context.makeLayoutGuide(identifier: "HStackConstraint.Relative")
          currentBox = .init(layoutGuide: newLayoutGuide)
          relativeConstraint.setupConstraints(parent: currentBox, in: context)
          perform()
          previous = currentBox

        case .vStack(let stackConstraint):

          let newLayoutGuide = context.makeLayoutGuide(identifier: "HStackConstraint.VStack")
          currentBox = .init(layoutGuide: newLayoutGuide)
          stackConstraint.setupConstraints(parent: currentBox, in: context)
          perform()
          previous = currentBox

        case .hStack(let stackConstraint):

          let newLayoutGuide = context.makeLayoutGuide(identifier: "HStackConstraint.HStack")
          currentBox = .init(layoutGuide: newLayoutGuide)
          stackConstraint.setupConstraints(parent: currentBox, in: context)
          perform()
          previous = currentBox

        case .zStack(let stackConstraint):

          let newLayoutGuide = context.makeLayoutGuide(identifier: "HStackConstraint.ZStack")
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
