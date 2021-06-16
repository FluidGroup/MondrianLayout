import UIKit

public struct VStackConstraint: LayoutDescriptorType, _RelativeContentConvertible,
  _BackgroundContentConvertible
{

  public let name = "VStack"

  public enum HorizontalAlignment {
    case leading
    case center
    case trailing
  }

  public var _relativeContent: _RelativeContent {
    return .vStack(self)
  }

  public var _backgroundContent: _BackgroundContent {
    return .vStack(self)
  }

  public let spacing: CGFloat
  public let alignment: HorizontalAlignment
  public let elements: [_VHStackContent]

  public init(
    spacing: CGFloat = 0,
    alignment: HorizontalAlignment = .center,
    @VHStackContentBuilder elements: () -> [_VHStackContent]
  ) {
    self.spacing = spacing
    self.alignment = alignment
    self.elements = elements()
  }

  public func setupConstraints(parent: _LayoutElement, in context: LayoutBuilderContext) {

    let parsed = elements

    guard parsed.isEmpty == false else {
      return
    }

    if parsed.count == 1 {

      let first = parsed.first!

      switch first {
      case .view(let viewConstraint):

        let view = viewConstraint.view

        context.register(viewConstraint: viewConstraint)

        // FIXME: case of single element, constraints

        context.add(constraints: [
          view.topAnchor.constraint(equalTo: parent.topAnchor).withInternalIdentifier("VStack.top"),
          view.leftAnchor.constraint(equalTo: parent.leftAnchor).withInternalIdentifier(
            "VStack.left"
          ),
          view.rightAnchor.constraint(equalTo: parent.rightAnchor).withInternalIdentifier(
            "VStack.right"
          ),
          view.bottomAnchor.constraint(equalTo: parent.bottomAnchor).withInternalIdentifier(
            "VStack.bottom"
          ),
        ])

      case .relative(let constraint as LayoutDescriptorType),
        .vStack(let constraint as LayoutDescriptorType),
        .hStack(let constraint as LayoutDescriptorType),
        .zStack(let constraint as LayoutDescriptorType),
        .background(let constraint as LayoutDescriptorType),
        .overlay(let constraint as LayoutDescriptorType):

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

          alignmentLayout: do {

            switch alignment {
            case .leading:
              context.add(constraints: [
                currentLayoutElement.leadingAnchor.constraint(equalTo: parent.leadingAnchor),
                currentLayoutElement.trailingAnchor.constraint(
                  lessThanOrEqualTo: parent.trailingAnchor
                ),
              ])
            case .center:
              context.add(constraints: [
                currentLayoutElement.leadingAnchor.constraint(
                  greaterThanOrEqualTo: parent.leadingAnchor
                ),
                currentLayoutElement.centerXAnchor.constraint(equalTo: parent.centerXAnchor),
                currentLayoutElement.trailingAnchor.constraint(
                  lessThanOrEqualTo: parent.trailingAnchor
                ),
              ])
            case .trailing:
              context.add(constraints: [
                currentLayoutElement.leadingAnchor.constraint(
                  greaterThanOrEqualTo: parent.leadingAnchor
                ),
                currentLayoutElement.trailingAnchor.constraint(equalTo: parent.trailingAnchor),
              ])
            }

          }

          stackingLayout: do {

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
        }

        switch element {
        case .view(let viewConstraint):

          let view = viewConstraint.view
          currentLayoutElement = .init(view: view)
          context.register(viewConstraint: viewConstraint)
          perform()
          previous = currentLayoutElement

        case .background(let c as LayoutDescriptorType),
          .overlay(let c as LayoutDescriptorType),
          .relative(let c as LayoutDescriptorType),
          .vStack(let c as LayoutDescriptorType),
          .hStack(let c as LayoutDescriptorType),
          .zStack(let c as LayoutDescriptorType):

          let newLayoutGuide = context.makeLayoutGuide(identifier: "VStackConstraint.\(c.name)")
          currentLayoutElement = .init(layoutGuide: newLayoutGuide)
          c.setupConstraints(parent: currentLayoutElement, in: context)
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

// MARK: Modifiers
