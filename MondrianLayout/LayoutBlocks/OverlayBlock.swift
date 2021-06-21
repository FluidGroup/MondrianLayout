import UIKit

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

    setupOverlay: do {

      let overlayLayoutGuide = context.makeLayoutGuide(identifier: "Overlay")

      context.add(constraints: [
        overlayLayoutGuide.topAnchor.constraint(equalTo: parent.topAnchor),
        overlayLayoutGuide.leftAnchor.constraint(equalTo: parent.leftAnchor),
        overlayLayoutGuide.bottomAnchor.constraint(equalTo: parent.bottomAnchor),
        overlayLayoutGuide.rightAnchor.constraint(equalTo: parent.rightAnchor),
        overlayLayoutGuide.widthAnchor.constraint(
          lessThanOrEqualTo: parent.widthAnchor,
          multiplier: 1
        ),
        overlayLayoutGuide.heightAnchor.constraint(
          lessThanOrEqualTo: parent.heightAnchor,
          multiplier: 1
        ),
      ])

      switch overlayContent {

      case .view(let c):

        context.register(viewConstraint: c)

        let guide = _LayoutElement(layoutGuide: overlayLayoutGuide)

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
          parent: .init(layoutGuide: overlayLayoutGuide),
          in: context
        )

      }

    }

  }

}
