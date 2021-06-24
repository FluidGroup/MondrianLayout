import UIKit

public protocol _LayoutBlockNodeConvertible: _VStackItemConvertible, _HStackItemConvertible, _ZStackItemConvertible {
  var _layoutBlockNode: _LayoutBlockNode { get }
}

extension _LayoutBlockNodeConvertible {
  public var _vStackItem: _VStackItem {
    return .init(node: _layoutBlockNode)
  }

  public var _hStackItem: _HStackItem {
    return .init(node: _layoutBlockNode)
  }

  public var _zStackItem: _ZStackItem {
    return .init(node: _layoutBlockNode)
  }
}

public indirect enum _LayoutBlockNode: _LayoutBlockNodeConvertible {

  case view(ViewBlock)
  case vStack(VStackBlock)
  case hStack(HStackBlock)
  case zStack(ZStackBlock)
  case relative(RelativeBlock)
  case overlay(OverlayBlock)
  case background(BackgroundBlock)

  public var _layoutBlockNode: _LayoutBlockNode { self }
}

extension _LayoutBlockNodeConvertible {

  public func background(_ view: UIView) -> BackgroundBlock {
    return .init(content: _layoutBlockNode, backgroundContent: .view(view.viewBlock))
  }

  public func background<Block: _LayoutBlockNodeConvertible>(_ block: Block) -> BackgroundBlock {
    return .init(content: _layoutBlockNode, backgroundContent: block._layoutBlockNode)
  }

  public func overlay(_ view: UIView) -> OverlayBlock {
    return .init(content: _layoutBlockNode, overlayContent: .view(view.viewBlock))
  }

  public func overlay<Block: _LayoutBlockNodeConvertible>(_ block: Block) -> OverlayBlock {
    return .init(content: _layoutBlockNode, overlayContent: block._layoutBlockNode)
  }
}

@_functionBuilder
public enum _LayoutBlockArrayBuilder {
  public typealias Component = _LayoutBlockNode

  public static func buildBlock(_ components: Component...) -> [Component] {
    return components
  }

  public static func buildExpression<View: UIView>(_ view: View) -> Component {
    return .view(.init(view))
  }

  public static func buildExpression<Block: _LayoutBlockNodeConvertible>(_ block: Block) -> Component {
    return block._layoutBlockNode
  }

}
