import UIKit

/// [MondrianLayout]
/// A descriptor that lays out the content and overlay content in the parent layout element.
public struct OverlayBlock:
  _LayoutBlockType
{

  // MARK: - Properties

  public var name: String = "Overlay"

  public var _layoutBlockNode: _LayoutBlockNode {
    .overlay(self)
  }

  public let content: _LayoutBlockNode
  public let overlayContent: _LayoutBlockNode

  // MARK: - Initializers

  init(
    content: _LayoutBlockNode,
    overlayContent: _LayoutBlockNode
  ) {

    self.content = content
    self.overlayContent = overlayContent

  }

  // MARK: - Functions

  public func setupConstraints(parent: _LayoutElement, in context: LayoutBuilderContext) {

    setupContent: do {

      switch content {
      case .layoutGuide(let block):
        context.register(layoutGuideBlock: block)
        context.add(
          constraints: block.makeConstraintsToEdge(parent)
        )
      case .view(let block):
        context.register(viewBlock: block)
        context.add(
          constraints: block.makeConstraintsToEdge(parent)
        )
      case .relative(let block as _LayoutBlockType),
           .vStack(let block as _LayoutBlockType),
           .hStack(let block as _LayoutBlockType),
           .zStack(let block as _LayoutBlockType),
           .overlay(let block as _LayoutBlockType),
           .background(let block as _LayoutBlockType):
        block.setupConstraints(parent: parent, in: context)
      }
    }

    setupOverlay: do {

      switch overlayContent {
      case .layoutGuide(let block):
        context.register(layoutGuideBlock: block)
        context.add(
          constraints: block.makeConstraintsToEdge(parent)
        )
      case .view(let block):

        context.register(viewBlock: block)

        context.add(
          constraints: block.makeConstraintsToEdge(parent)
        )

      case .relative(let block as _LayoutBlockType),
           .vStack(let block as _LayoutBlockType),
           .hStack(let block as _LayoutBlockType),
           .zStack(let block as _LayoutBlockType),
           .overlay(let block as _LayoutBlockType),
           .background(let block as _LayoutBlockType):

        let overlayLayoutGuide = context.makeLayoutGuide(identifier: "Overlay")

        context.add(
          constraints:
            overlayLayoutGuide.mondrian.layout.edges(.to(parent)).makeConstraints()
        )

        block.setupConstraints(
          parent: .init(layoutGuide: overlayLayoutGuide),
          in: context
        )

      }

    }

  }

}
