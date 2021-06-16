import UIKit

public protocol _LayeringContentConvertible {
  var _layeringContent: _LayeringContent { get }
}

public indirect enum _LayeringContent {

  case view(ViewBlock)
  case vStack(VStackBlock)
  case hStack(HStackBlock)
  case zStack(ZStackBlock)
  case relative(RelativeBlock)
  case overlay(OverlayBlock)
  case background(BackgroundBlock)
}

extension _LayeringContentConvertible {

  public func background(_ view: UIView) -> BackgroundBlock {
    return .init(content: _layeringContent, backgroundContent: .view(view.viewBlock))
  }

  public func background(_ constraint: ViewBlock) -> BackgroundBlock {
    return .init(content: _layeringContent, backgroundContent: .view(constraint))
  }

  public func background(_ constraint: RelativeBlock) -> BackgroundBlock {
    return .init(content: _layeringContent, backgroundContent: .relative(constraint))
  }

  public func background(_ constraint: VStackBlock) -> BackgroundBlock {
    return .init(content: _layeringContent, backgroundContent: .vStack(constraint))
  }

  public func background(_ constraint: HStackBlock) -> BackgroundBlock {
    return .init(content: _layeringContent, backgroundContent: .hStack(constraint))
  }

  public func background(_ constraint: ZStackBlock) -> BackgroundBlock {
    return .init(content: _layeringContent, backgroundContent: .zStack(constraint))
  }

  public func background(_ constraint: BackgroundBlock) -> BackgroundBlock {
    return .init(content: _layeringContent, backgroundContent: .background(constraint))
  }


  public func background(_ constraint: OverlayBlock) -> BackgroundBlock {
    return .init(content: _layeringContent, backgroundContent: .overlay(constraint))
  }

  public func overlay(_ view: UIView) -> OverlayBlock {
    return .init(content: _layeringContent, overlayContent: .view(view.viewBlock))
  }

  public func overlay(_ constraint: ViewBlock) -> OverlayBlock {
    return .init(content: _layeringContent, overlayContent: .view(constraint))
  }

  public func overlay(_ constraint: RelativeBlock) -> OverlayBlock {
    return .init(content: _layeringContent, overlayContent: .relative(constraint))
  }

  public func overlay(_ constraint: VStackBlock) -> OverlayBlock {
    return .init(content: _layeringContent, overlayContent: .vStack(constraint))
  }

  public func overlay(_ constraint: HStackBlock) -> OverlayBlock {
    return .init(content: _layeringContent, overlayContent: .hStack(constraint))
  }

  public func overlay(_ constraint: ZStackBlock) -> OverlayBlock {
    return .init(content: _layeringContent, overlayContent: .zStack(constraint))
  }

  public func overlay(_ constraint: OverlayBlock) -> OverlayBlock {
    return .init(content: _layeringContent, overlayContent: .overlay(constraint))
  }

  public func overlay(_ constraint: BackgroundBlock) -> OverlayBlock {
    return .init(content: _layeringContent, overlayContent: .background(constraint))
  }
}

@_functionBuilder
public enum _LayeringContentBuilder {
  public typealias Component = _LayeringContent

  @_disfavoredOverload
  public static func buildBlock(_ components: Component...) -> [Component] {
    return components
  }

  public static func buildExpression<View: UIView>(_ view: View) -> Component {
    return .view(.init(view))
  }

  public static func buildExpression(_ stack: HStackBlock) -> Component {
    return .hStack(stack)
  }

  public static func buildExpression(_ stack: VStackBlock) -> Component {
    return .vStack(stack)
  }

  public static func buildExpression(_ stack: ZStackBlock) -> Component {
    return .zStack(stack)
  }

  public static func buildExpression(_ stack: RelativeBlock) -> Component {
    return .relative(stack)
  }

  public static func buildExpression(_ view: ViewBlock) -> Component {
    return .view(view)
  }

  public static func buildExpression(_ background: BackgroundBlock) -> Component {
    return .background(background)
  }

  public static func buildExpression(_ overlay: OverlayBlock) -> Component {
    return .overlay(overlay)
  }
}
