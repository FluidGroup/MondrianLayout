import UIKit

public enum LayoutContainerBoundary<Anchor: Equatable>: Equatable {
  case safeArea(Anchor)
  case view(Anchor)
}

/**
 [MondrianLayout]
 A representation that describes a container for laying out subviews.
 */
public struct LayoutContainer {

  private let top: LayoutContainerBoundary<_LayoutElement.YAxisAnchor>
  private let leading: LayoutContainerBoundary<_LayoutElement.XAxisAnchor>
  private let bottom: LayoutContainerBoundary<_LayoutElement.YAxisAnchor>
  private let trailing: LayoutContainerBoundary<_LayoutElement.XAxisAnchor>

  private let content: _LayoutBlockNode

  /**
   Attaching to safeArea specified edges
   */
  public init<Block: _LayoutBlockNodeConvertible>(
    attachedSafeAreaEdges: Edge.Set,
    content: () -> Block
  ) {

    self.init(
      top: attachedSafeAreaEdges.contains(.top) ? .safeArea(.top) : .view(.top),
      leading: attachedSafeAreaEdges.contains(.leading) ? .safeArea(.leading) : .view(.leading),
      bottom: attachedSafeAreaEdges.contains(.bottom) ? .safeArea(.bottom) : .view(.bottom),
      trailing: attachedSafeAreaEdges.contains(.trailing) ? .safeArea(.trailing) : .view(.trailing),
      content: content
    )

  }

  /**
   Attaching to edge specified anchor of layout guide or view.

   It helps to lay out views outside of safe area.
   */
  public init<Block: _LayoutBlockNodeConvertible>(
    top: LayoutContainerBoundary<_LayoutElement.YAxisAnchor>,
    leading: LayoutContainerBoundary<_LayoutElement.XAxisAnchor>,
    bottom: LayoutContainerBoundary<_LayoutElement.YAxisAnchor>,
    trailing: LayoutContainerBoundary<_LayoutElement.XAxisAnchor>,
    content: () -> Block
  ) {

    self.top = top
    self.leading = leading
    self.bottom = bottom
    self.trailing = trailing

    self.content = content()._layoutBlockNode
  }

  /**
   Internal method
   */
  func setupConstraints(parent: UIView, in context: LayoutBuilderContext) {

    func prepareLayoutContainer() -> _LayoutElement {

      if top == .view(.top), leading == .view(.leading), bottom == .view(.bottom),
        trailing == .view(.trailing)
      {
        return .init(view: parent)
      }

      if top == .view(.top), leading == .view(.left), bottom == .view(.bottom),
        trailing == .view(.right)
      {
        return .init(view: parent)
      }

      if top == .safeArea(.top), leading == .safeArea(.leading), bottom == .safeArea(.bottom),
        trailing == .safeArea(.trailing)
      {
        return .init(layoutGuide: parent.safeAreaLayoutGuide)
      } else {

        let containerLayoutGuide = context.makeLayoutGuide(identifier: "LayoutContainer")

        let containerElement = _LayoutElement(layoutGuide: containerLayoutGuide)

        let parentElement = _LayoutElement(view: parent)
        let layoutGuideElement = _LayoutElement(layoutGuide: parent.safeAreaLayoutGuide)

        switch top {
        case .view(let anchor):
          context.add(constraints: [
            containerLayoutGuide.topAnchor.constraint(equalTo: parentElement.anchor(anchor))
          ])

        case .safeArea(let anchor):
          context.add(constraints: [
            containerLayoutGuide.topAnchor.constraint(equalTo: layoutGuideElement.anchor(anchor))
          ])
        }

        switch leading {
        case .view(let anchor):
          context.add(constraints: [
            containerLayoutGuide.leadingAnchor.constraint(equalTo: parentElement.anchor(anchor))
          ])

        case .safeArea(let anchor):
          context.add(constraints: [
            containerLayoutGuide.leadingAnchor.constraint(
              equalTo: layoutGuideElement.anchor(anchor)
            )
          ])
        }

        switch bottom {
        case .view(let anchor):
          context.add(constraints: [
            containerLayoutGuide.bottomAnchor.constraint(equalTo: parentElement.anchor(anchor))
          ])

        case .safeArea(let anchor):
          context.add(constraints: [
            containerLayoutGuide.bottomAnchor.constraint(equalTo: layoutGuideElement.anchor(anchor))
          ])
        }

        switch trailing {
        case .view(let anchor):
          context.add(constraints: [
            containerLayoutGuide.trailingAnchor.constraint(equalTo: parentElement.anchor(anchor))
          ])

        case .safeArea(let anchor):
          context.add(constraints: [
            containerLayoutGuide.trailingAnchor.constraint(
              equalTo: layoutGuideElement.anchor(anchor)
            )
          ])
        }

        return containerElement
      }

    }

    switch content {
    case .layoutGuide(let block):

      context.register(layoutGuideBlock: block)
      context.add(constraints: block.makeConstraintsToEdge(prepareLayoutContainer()))

    case .view(let block):

      context.register(viewBlock: block)
      context.add(constraints: block.makeConstraintsToEdge(prepareLayoutContainer()))

    case .vStack(let c as _LayoutBlockType),
      .hStack(let c as _LayoutBlockType),
      .zStack(let c as _LayoutBlockType),
      .overlay(let c as _LayoutBlockType),
      .relative(let c as _LayoutBlockType),
      .background(let c as _LayoutBlockType),
      .vGrid(let c as _LayoutBlockType):

      c.setupConstraints(parent: prepareLayoutContainer(), in: context)

    }

  }
}

extension _LayoutBlockType {

  /**
   Converts to ``LayoutContainer`` wrapping this block.
   */
  public func container(respectingSafeAreaEdges edges: Edge.Set) -> LayoutContainer {
    return .init(attachedSafeAreaEdges: edges, content: { self })
  }

  /**
   Converts to ``LayoutContainer`` wrapping this block.
   */
  public func container(
    top: LayoutContainerBoundary<_LayoutElement.YAxisAnchor>,
    leading: LayoutContainerBoundary<_LayoutElement.XAxisAnchor>,
    bottom: LayoutContainerBoundary<_LayoutElement.YAxisAnchor>,
    trailing: LayoutContainerBoundary<_LayoutElement.XAxisAnchor>
  ) -> LayoutContainer {
    return .init(top: top, leading: leading, bottom: bottom, trailing: trailing, content: { self })
  }
}
