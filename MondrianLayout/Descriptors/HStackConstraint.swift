import UIKit

public struct HStackConstraint:
  LayoutDescriptorType,
  _RelativeContentConvertible,
  _LayeringContentConvertible
{

  public enum VerticalAlignment {
    case top
    case center
    case bottom
    case fill
  }

  // MARK: - Properties

  public var name: String = "HStack"

  public var _relativeContent: _RelativeContent {
    return .hStack(self)
  }

  public var _layeringContent: _LayeringContent {
    return .hStack(self)
  }

  public var spacing: CGFloat
  public var alignment: VerticalAlignment
  public var elements: [HStackContentBuilder.Component]

  // MARK: - Initializers

  public init(
    spacing: CGFloat = 0,
    alignment: VerticalAlignment = .center,
    @HStackContentBuilder elements: () -> [HStackContentBuilder.Component]
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

    func align(layoutElement: _LayoutElement, alignment: VerticalAlignment) {
      switch alignment {
        case .top:
          context.add(constraints: [
            layoutElement.topAnchor.constraint(equalTo: parent.topAnchor),
            layoutElement.bottomAnchor.constraint(
              lessThanOrEqualTo: parent.bottomAnchor
            ),
          ])
        case .center:
          context.add(constraints: [
            layoutElement.topAnchor.constraint(greaterThanOrEqualTo: parent.topAnchor),
            layoutElement.bottomAnchor.constraint(
              lessThanOrEqualTo: parent.bottomAnchor
            ),
            layoutElement.centerYAnchor.constraint(equalTo: parent.centerYAnchor),
          ])
        case .bottom:
          context.add(constraints: [
            layoutElement.topAnchor.constraint(greaterThanOrEqualTo: parent.topAnchor),
            layoutElement.bottomAnchor.constraint(equalTo: parent.bottomAnchor),
          ])
        case .fill:
          context.add(constraints: [
            layoutElement.topAnchor.constraint(equalTo: parent.topAnchor),
            layoutElement.bottomAnchor.constraint(equalTo: parent.bottomAnchor),
          ])
        }
    }

    if parsed.count == 1 {

      let first = parsed.first!

      switch first.content {
      case .view(let viewConstraint):

        let view = viewConstraint.view

        context.register(viewConstraint: viewConstraint)

        align(layoutElement: .init(view: view), alignment: first.alignSelf ?? alignment)

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

          align(layoutElement: currentLayoutElement, alignment: element.alignSelf ?? alignment)

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

        switch element.content {
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
