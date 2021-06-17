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

    guard elements.isEmpty == false else {
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

    var boxes: [_LayoutElement] = []

    for (index, element) in elements.enumerated() {

      func appendSpacingIfNeeded() {
        if spacing > 0, index != elements.indices.last {
          let spacingGuide = context.makeLayoutGuide(identifier: "HStackBlock.Spacing")
          boxes.append(.init(layoutGuide: spacingGuide))
          context.add(constraints: [
            spacingGuide.widthAnchor.constraint(equalToConstant: spacing)
          ])
          align(layoutElement: .init(layoutGuide: spacingGuide), alignment: alignment)
        }
      }

      switch element.content {
      case .view(let viewConstraint):

        let view = viewConstraint.view
        context.register(viewConstraint: viewConstraint)
        boxes.append(.init(view: view))

        align(layoutElement: .init(view: view), alignment: element.alignSelf ?? alignment)
        appendSpacingIfNeeded()

      case .background(let c as LayoutDescriptorType),
           .overlay(let c as LayoutDescriptorType),
           .relative(let c as LayoutDescriptorType),
           .vStack(let c as LayoutDescriptorType),
           .hStack(let c as LayoutDescriptorType),
           .zStack(let c as LayoutDescriptorType):

        let newLayoutGuide = context.makeLayoutGuide(identifier: "HStackBlock.\(c.name)")
        c.setupConstraints(parent: .init(layoutGuide: newLayoutGuide), in: context)
        boxes.append(.init(layoutGuide: newLayoutGuide))

        align(layoutElement: .init(layoutGuide: newLayoutGuide), alignment: element.alignSelf ?? alignment)
        appendSpacingIfNeeded()

      case .spacer(let spacer):

        // TODO: optimize spacing, accumulating continuous spacing.

        let newLayoutGuide = context.makeLayoutGuide(identifier: "HStackBlock.Spacer")
        boxes.append(.init(layoutGuide: newLayoutGuide))

        if spacer.expands {
          context.add(constraints: [
            newLayoutGuide.widthAnchor.constraint(greaterThanOrEqualToConstant: spacer.minLength)
          ])
        } else {
          context.add(constraints: [
            newLayoutGuide.widthAnchor.constraint(equalToConstant: spacer.minLength)
          ])
        }

        align(layoutElement: .init(layoutGuide: newLayoutGuide), alignment: alignment)

      }

    }

    let firstBox = boxes.first!

    let lastBox = boxes.dropFirst().reduce(firstBox) { previousBox, box in

      context.add(constraints: [
        box.leadingAnchor.constraint(
          equalTo: previousBox.trailingAnchor,
          constant: 0
        )
      ])

      return box
    }

    context.add(constraints: [
      firstBox.leadingAnchor.constraint(
        equalTo: parent.leadingAnchor,
        constant: 0
      )
    ])

    context.add(constraints: [
      lastBox.trailingAnchor.constraint(
        equalTo: parent.trailingAnchor,
        constant: 0
      )
    ])

  }

}
