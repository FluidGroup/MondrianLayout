import UIKit

public struct VStackConstraint: LayoutDescriptorType, _RelativeContentConvertible {

  public enum HorizontalAlignment {
    case leading
    case center
    case trailing
    case fill
  }

  public var _relativeContent: _RelativeContent {
    .vStack(self)
  }

  public let spacing: CGFloat
  public let alignment: HorizontalAlignment
  public let elements: [_VHStackContent]

  public init(
    spacing: CGFloat = 0,
    alignment: HorizontalAlignment = .fill,
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
          view.topAnchor.constraint(equalTo: parent.topAnchor).withInternalIdentifier("VStack.top"),
          view.leftAnchor.constraint(equalTo: parent.leftAnchor).withInternalIdentifier("VStack.left"),
          view.rightAnchor.constraint(equalTo: parent.rightAnchor).withInternalIdentifier("VStack.right"),
          view.bottomAnchor.constraint(equalTo: parent.bottomAnchor).withInternalIdentifier("VStack.bottom"),
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
      var currentLayoutElement: _LayoutElement!

      for (i, element) in parsed.enumerated() {

        func perform() {

          hasStartedLayout = true

          context.add(constraints: [
            currentLayoutElement.leftAnchor.constraint(equalTo: parent.leftAnchor),
            currentLayoutElement.rightAnchor.constraint(equalTo: parent.rightAnchor),
          ])

          if let previous = previous {

            if elements.indices.last == i {
              // last element
              context.add(constraints: [
                currentLayoutElement.topAnchor.constraint(
                  equalTo: previous.bottomAnchor,
                  constant: spaceToPrevious
                ),
                currentLayoutElement.bottomAnchor.constraint(equalTo: parent.bottomAnchor),
              ])
            } else {
              // middle element
              context.add(constraints: [
                currentLayoutElement.topAnchor.constraint(
                  equalTo: previous.bottomAnchor,
                  constant: spaceToPrevious
                )
              ])
            }
          } else {
            // first element
            context.add(constraints: [
              currentLayoutElement.topAnchor.constraint(
                equalTo: parent.topAnchor,
                constant: initialSpace
              )
            ])
          }

          spaceToPrevious = spacing
        }

        switch element {
        case .view(let viewConstraint):

          let view = viewConstraint.view
          currentLayoutElement = .init(view: view)
          context.register(view: viewConstraint)
          perform()
          previous = currentLayoutElement

        case .relative(let relativeConstraint):

          let newLayoutGuide = context.makeLayoutGuide(identifier: "VStackConstraint.Relative")
          currentLayoutElement = .init(layoutGuide: newLayoutGuide)
          relativeConstraint.setupConstraints(parent: currentLayoutElement, in: context)
          perform()
          previous = currentLayoutElement

        case .vStack(let stackConstraint):

          let newLayoutGuide = context.makeLayoutGuide(identifier: "VStackConstraint.VStack")
          currentLayoutElement = .init(layoutGuide: newLayoutGuide)
          stackConstraint.setupConstraints(parent: currentLayoutElement, in: context)
          perform()
          previous = currentLayoutElement

        case .hStack(let stackConstraint):

          let newLayoutGuide = context.makeLayoutGuide(identifier: "VStackConstraint.HStack")
          currentLayoutElement = .init(layoutGuide: newLayoutGuide)
          stackConstraint.setupConstraints(parent: currentLayoutElement, in: context)
          perform()
          previous = currentLayoutElement

        case .zStack(let stackConstraint):

          let newLayoutGuide = context.makeLayoutGuide(identifier: "VStackConstraint.ZStack")
          currentLayoutElement = .init(layoutGuide: newLayoutGuide)
          stackConstraint.setupConstraints(parent: currentLayoutElement, in: context)
          perform()
          previous = currentLayoutElement

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
