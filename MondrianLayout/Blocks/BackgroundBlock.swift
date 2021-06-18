import UIKit

public struct BackgroundBlock:
  LayoutDescriptorType,
  _RelativeContentConvertible
{

  // MARK: - Properties

  public var name: String = "Background"

  public var _relativeContent: _RelativeContent {
    return .background(self)
  }

  let content: _LayeringContent
  let backgroundContent: _LayeringContent

  // MARK: - Initializers

  init(
    content: _LayeringContent,
    backgroundContent: _LayeringContent
  ) {

    self.content = content
    self.backgroundContent = backgroundContent
  }

  // MARK: - Functions

  public func setupConstraints(parent: _LayoutElement, in context: LayoutBuilderContext) {

    setupBackground: do {

      let backgroundLayoutGuide = context.makeLayoutGuide(identifier: "Background")

      context.add(constraints: [
        backgroundLayoutGuide.topAnchor.constraint(equalTo: parent.topAnchor),
        backgroundLayoutGuide.leftAnchor.constraint(equalTo: parent.leftAnchor),
        backgroundLayoutGuide.bottomAnchor.constraint(equalTo: parent.bottomAnchor),
        backgroundLayoutGuide.rightAnchor.constraint(equalTo: parent.rightAnchor),
        backgroundLayoutGuide.widthAnchor.constraint(
          lessThanOrEqualTo: parent.widthAnchor,
          multiplier: 1
        ),
        backgroundLayoutGuide.heightAnchor.constraint(
          lessThanOrEqualTo: parent.heightAnchor,
          multiplier: 1
        ),
      ])

      switch backgroundContent {

      case .view(let c):

        context.register(viewConstraint: c)

        let guide = _LayoutElement(layoutGuide: backgroundLayoutGuide)

        context.add(
          constraints: [
            c.view.topAnchor.constraint(equalTo: guide.topAnchor),
            c.view.rightAnchor.constraint(equalTo: guide.rightAnchor),
            c.view.leftAnchor.constraint(equalTo: guide.leftAnchor),
            c.view.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
          ]
        )

      case .relative(let c as LayoutDescriptorType),
           .vStack(let c as LayoutDescriptorType),
           .hStack(let c as LayoutDescriptorType),
           .zStack(let c as LayoutDescriptorType),
           .overlay(let c as LayoutDescriptorType),
           .background(let c as LayoutDescriptorType):

        c.setupConstraints(
          parent: .init(layoutGuide: backgroundLayoutGuide),
          in: context
        )
      }

    }

    setupContent: do {

      switch content {
      case .view(let c):
        context.register(viewConstraint: c)
        context.add(
          constraints: [
            c.view.topAnchor.constraint(equalTo: parent.topAnchor),
            c.view.rightAnchor.constraint(equalTo: parent.rightAnchor),
            c.view.leftAnchor.constraint(equalTo: parent.leftAnchor),
            c.view.bottomAnchor.constraint(equalTo: parent.bottomAnchor),
          ]
        )
      case .relative(let c as LayoutDescriptorType),
           .vStack(let c as LayoutDescriptorType),
           .hStack(let c as LayoutDescriptorType),
           .zStack(let c as LayoutDescriptorType),
           .overlay(let c as LayoutDescriptorType),
           .background(let c as LayoutDescriptorType):
        c.setupConstraints(parent: parent, in: context)
      }
    }
  }
}
