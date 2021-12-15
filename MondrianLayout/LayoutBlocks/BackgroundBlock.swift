import UIKit

/// [MondrianLayout]
/// A descriptor that lays out the content and background content in the parent layout element.
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

      switch backgroundContent {
      case .layoutGuide(let block):

        context.register(layoutGuideBlock: block)
        context.add(
          constraints: block.makeConstraintsToEdge(parent)
        )

      case .view(let c):

        context.register(viewBlock: c)
        context.add(
          constraints: c.makeConstraintsToEdge(parent)
        )

      case .relative(let c as _LayoutBlockType),
        .vStack(let c as _LayoutBlockType),
        .hStack(let c as _LayoutBlockType),
        .zStack(let c as _LayoutBlockType),
        .overlay(let c as _LayoutBlockType),
        .background(let c as _LayoutBlockType),
        .vGrid(let c as _LayoutBlockType):

        let backgroundLayoutGuide = context.makeLayoutGuide(identifier: "Background")

        context.add(
          constraints:
            backgroundLayoutGuide.mondrian.layout.edges(.to(parent)).makeConstraints()
        )

        c.setupConstraints(
          parent: .init(layoutGuide: backgroundLayoutGuide),
          in: context
        )
      }

    }

    setupContent: do {

      switch content {
      case .layoutGuide(let block):

        context.register(layoutGuideBlock: block)
        context.add(
          constraints: block.makeConstraintsToEdge(parent)
        )

      case .view(let c):
        context.register(viewBlock: c)
        context.add(
          constraints: c.makeConstraintsToEdge(parent)
        )
      case .relative(let c as _LayoutBlockType),
        .vStack(let c as _LayoutBlockType),
        .hStack(let c as _LayoutBlockType),
        .zStack(let c as _LayoutBlockType),
        .overlay(let c as _LayoutBlockType),
        .background(let c as _LayoutBlockType),
        .vGrid(let c as _LayoutBlockType):
        c.setupConstraints(parent: parent, in: context)
      }
    }

  }
}
