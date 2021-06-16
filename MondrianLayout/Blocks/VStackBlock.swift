import UIKit

public struct VStackBlock:
  LayoutDescriptorType,
  _RelativeContentConvertible,
  _LayeringContentConvertible
{

  public let name = "VStack"

  public enum HorizontalAlignment {
    case leading
    case center
    case trailing
    case fill
  }

  // MARK: - Properties

  public var _relativeContent: _RelativeContent {
    return .vStack(self)
  }

  public var _layeringContent: _LayeringContent {
    return .vStack(self)
  }

  public var spacing: CGFloat
  public var alignment: HorizontalAlignment
  public var elements: [VStackContentBuilder.Component]

  // MARK: - Initializers

  public init(
    spacing: CGFloat = 0,
    alignment: HorizontalAlignment = .center,
    @VStackContentBuilder elements: () -> [VStackContentBuilder.Component]
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

    func align(layoutElement: _LayoutElement, alignment: HorizontalAlignment) {
      switch alignment {
      case .leading:
        context.add(constraints: [
          layoutElement.leadingAnchor.constraint(equalTo: parent.leadingAnchor),
          layoutElement.trailingAnchor.constraint(
            lessThanOrEqualTo: parent.trailingAnchor
          ),
        ])
      case .center:
        context.add(constraints: [
          layoutElement.leadingAnchor.constraint(
            greaterThanOrEqualTo: parent.leadingAnchor
          ),
          layoutElement.centerXAnchor.constraint(equalTo: parent.centerXAnchor),
          layoutElement.trailingAnchor.constraint(
            lessThanOrEqualTo: parent.trailingAnchor
          ),
        ])
      case .trailing:
        context.add(constraints: [
          layoutElement.leadingAnchor.constraint(
            greaterThanOrEqualTo: parent.leadingAnchor
          ),
          layoutElement.trailingAnchor.constraint(equalTo: parent.trailingAnchor),
        ])
      case .fill:
        context.add(constraints: [
          layoutElement.leadingAnchor.constraint(
            equalTo: parent.leadingAnchor
          ),
          layoutElement.trailingAnchor.constraint(equalTo: parent.trailingAnchor),
        ])
      }
    }

    if parsed.count == 1 {

      let first = parsed.first!

      switch first.content {
      case .view(let viewConstraint):

        let view = viewConstraint.view

        context.register(viewConstraint: viewConstraint)

        // FIXME: case of single element, constraints

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

          let newLayoutGuide = context.makeLayoutGuide(identifier: "VStackBlock.\(c.name)")
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
