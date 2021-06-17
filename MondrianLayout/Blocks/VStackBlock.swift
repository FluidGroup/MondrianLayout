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

    var state: DistributingState = .init()

    for element in parsed {

      func perform() {

        state.hasStartedLayout = true

        align(layoutElement: state.currentLayoutElement, alignment: element.alignSelf ?? alignment)

        stackingLayout: do {

          if let previous = state.previous {

            if state.isEpandableSpace() {

              context.add(constraints: [
                state.currentLayoutElement.topAnchor.constraint(
                  greaterThanOrEqualTo: previous.bottomAnchor,
                  constant: state.totalSpace()
                )
              ])

            } else {

              context.add(constraints: [
                state.currentLayoutElement.topAnchor.constraint(
                  equalTo: previous.bottomAnchor,
                  constant: state.totalSpace()
                )
              ])
            }

          } else {
            // first element

            if state.initialSpace.expands {
              context.add(constraints: [
                state.currentLayoutElement.topAnchor.constraint(
                  greaterThanOrEqualTo: parent.topAnchor,
                  constant: state.initialSpace.minLength
                )
              ])
            } else {
              context.add(constraints: [
                state.currentLayoutElement.topAnchor.constraint(
                  equalTo: parent.topAnchor,
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

        let newLayoutGuide = context.makeLayoutGuide(identifier: "VStackBlock.\(c.name)")
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
          state.currentLayoutElement.bottomAnchor.constraint(
            lessThanOrEqualTo: parent.bottomAnchor,
            constant: -(state.totalSpace() - spacing)
          )
        ])
      } else {
        context.add(constraints: [
          state.currentLayoutElement.bottomAnchor.constraint(
            equalTo: parent.bottomAnchor,
            constant: -(state.totalSpace() - spacing)
          )
        ])
      }

    }
  }
}
