import UIKit

public struct HStackConstraint:
  LayoutDescriptorType,
  _RelativeContentConvertible,
  _BackgroundContentConvertible
{

  public enum VerticalAlignment {
    case top
    case center
    case bottom
  }

  // MARK: - Properties

  public var name: String = "HStack"

  public var _relativeContent: _RelativeContent {
    return .hStack(self)
  }

  public var _backgroundContent: _BackgroundContent {
    return .hStack(self)
  }

  public var spacing: CGFloat
  public var alignment: VerticalAlignment
  public var elements: [_VHStackContent]

  // MARK: - Initializers

  public init(
    spacing: CGFloat = 0,
    alignment: VerticalAlignment = .center,
    @VHStackContentBuilder elements: () -> [_VHStackContent]
  ) {
    self.spacing = spacing
    self.alignment = alignment
    self.elements = elements()
  }

  // MARK: - Functions

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
          view.topAnchor.constraint(equalTo: parent.topAnchor).withInternalIdentifier("HStack.top"),
          view.leftAnchor.constraint(equalTo: parent.leftAnchor).withInternalIdentifier(
            "HStack.left"
          ),
          view.rightAnchor.constraint(equalTo: parent.rightAnchor).withInternalIdentifier(
            "HStack.right"
          ),
          view.bottomAnchor.constraint(equalTo: parent.bottomAnchor).withInternalIdentifier(
            "HStack.bottom"
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
            case .top:
              context.add(constraints: [
                currentLayoutElement.topAnchor.constraint(equalTo: parent.topAnchor),
                currentLayoutElement.bottomAnchor.constraint(
                  lessThanOrEqualTo: parent.bottomAnchor
                ),
              ])
            case .center:
              context.add(constraints: [
                currentLayoutElement.topAnchor.constraint(greaterThanOrEqualTo: parent.topAnchor),
                currentLayoutElement.bottomAnchor.constraint(
                  lessThanOrEqualTo: parent.bottomAnchor
                ),
                currentLayoutElement.centerYAnchor.constraint(equalTo: parent.centerYAnchor),
              ])
            case .bottom:
              context.add(constraints: [
                currentLayoutElement.topAnchor.constraint(greaterThanOrEqualTo: parent.topAnchor),
                currentLayoutElement.bottomAnchor.constraint(equalTo: parent.bottomAnchor),
              ])
            }
          }

          if let previous = previous {

            if elements.indices.last == i {
              // last element
              context.add(constraints: [
                currentLayoutElement.leftAnchor.constraint(
                  equalTo: previous.rightAnchor,
                  constant: spaceToPrevious
                ),
                currentLayoutElement.rightAnchor.constraint(equalTo: parent.rightAnchor),
              ])
            } else {
              // middle element
              context.add(constraints: [
                currentLayoutElement.leftAnchor.constraint(
                  equalTo: previous.rightAnchor,
                  constant: spaceToPrevious
                )
              ])
            }
          } else {
            // first element
            context.add(constraints: [
              currentLayoutElement.leftAnchor.constraint(
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

          let newLayoutGuide = context.makeLayoutGuide(identifier: "HStackConstraint.\(c.name)")
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
