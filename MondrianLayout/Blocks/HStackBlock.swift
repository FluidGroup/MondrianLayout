import UIKit

public struct HStackBlock:
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

      var state: DistributingState = .init()

      for element in parsed {

        func perform() {

          state.hasStartedLayout = true

          align(
            layoutElement: state.currentLayoutElement,
            alignment: element.alignSelf ?? alignment
          )

          stackingLayout: do {

            if let previous = state.previous {

              if state.isEpandableSpace() {

                context.add(constraints: [
                  state.currentLayoutElement.leadingAnchor.constraint(
                    greaterThanOrEqualTo: previous.trailingAnchor,
                    constant: state.totalSpace()
                  )
                ])

              } else {

                context.add(constraints: [
                  state.currentLayoutElement.leadingAnchor.constraint(
                    equalTo: previous.trailingAnchor,
                    constant: state.totalSpace()
                  )
                ])
              }

            } else {
              // first element

              if state.initialSpace.expands {
                context.add(constraints: [
                  state.currentLayoutElement.leadingAnchor.constraint(
                    greaterThanOrEqualTo: parent.leadingAnchor,
                    constant: state.initialSpace.minLength
                  )
                ])
              } else {
                context.add(constraints: [
                  state.currentLayoutElement.leadingAnchor.constraint(
                    equalTo: parent.leadingAnchor,
                    constant: state.initialSpace.minLength
                  )
                ])
              }

            }

          }

        }

        switch element.content {
        case .view(let viewConstraint):

          let view = viewConstraint.view
          state.currentLayoutElement = .init(view: view)
          context.register(viewConstraint: viewConstraint)

          perform()

          state.previous = state.currentLayoutElement
          state.resetSpacingInterItem(SpacerBlock(minLength: spacing, expands: false))

        case .background(let c as LayoutDescriptorType),
          .overlay(let c as LayoutDescriptorType),
          .relative(let c as LayoutDescriptorType),
          .vStack(let c as LayoutDescriptorType),
          .hStack(let c as LayoutDescriptorType),
          .zStack(let c as LayoutDescriptorType):

          let newLayoutGuide = context.makeLayoutGuide(identifier: "HStackBlock.\(c.name)")
          state.currentLayoutElement = .init(layoutGuide: newLayoutGuide)
          c.setupConstraints(parent: state.currentLayoutElement, in: context)
          perform()

          state.previous = state.currentLayoutElement
          state.resetSpacingInterItem(SpacerBlock(minLength: spacing, expands: false))

        case .spacer(let spacer):

          if state.hasStartedLayout == false {
            state.initialSpace = spacer
          } else {
            state.appendSpacer(spacer)
          }

        }

      }

      finalize: do {

        // last element

        if state.isEpandableSpace() {
          context.add(constraints: [
            state.currentLayoutElement.trailingAnchor.constraint(
              lessThanOrEqualTo: parent.trailingAnchor,
              constant: -(state.totalSpace() - spacing)
            )
          ])
        } else {
          context.add(constraints: [
            state.currentLayoutElement.trailingAnchor.constraint(
              equalTo: parent.trailingAnchor,
              constant: -(state.totalSpace() - spacing)
            )
          ])
        }

      }
    }

  }

}
