import UIKit

public struct BackgroundBlock:
  _LayoutBlockType
{

  // MARK: - Properties

  public var name: String = "Background"

  public var _layoutBlockNode: _LayoutBlockNode {
    .background(self)
  }

  let content: _LayoutBlockNode
  let backgroundContent: _LayoutBlockNode

  // MARK: - Initializers

  init(
    content: _LayoutBlockNode,
    backgroundContent: _LayoutBlockNode
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
          constraints: c.makeConstraintsToEdge(guide)
        )

      case .relative(let c as _LayoutBlockType),
           .vStack(let c as _LayoutBlockType),
           .hStack(let c as _LayoutBlockType),
           .zStack(let c as _LayoutBlockType),
           .overlay(let c as _LayoutBlockType),
           .background(let c as _LayoutBlockType):

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
          constraints: c.makeConstraintsToEdge(parent)
        )
      case .relative(let c as _LayoutBlockType),
           .vStack(let c as _LayoutBlockType),
           .hStack(let c as _LayoutBlockType),
           .zStack(let c as _LayoutBlockType),
           .overlay(let c as _LayoutBlockType),
           .background(let c as _LayoutBlockType):
        c.setupConstraints(parent: parent, in: context)
      }
    }
  }
}
