import UIKit

protocol _StackElementNodeType {

  associatedtype ItemType: StackItemType

  static func spacer(_ spacer: StackingSpacer) -> Self
  static func content(_ item: ItemType) -> Self

  var _content: ItemType? { get }
  var _spacer: StackingSpacer? { get }
}

public enum _VStackElementNode: _StackElementNodeType {

  case content(_VStackItem)
  case spacer(StackingSpacer)

  var _content: _VStackItem? {
    guard case .content(let value) = self else {
      return nil
    }
    return value
  }

  var _spacer: StackingSpacer? {
    guard case .spacer(let value) = self else {
      return nil
    }
    return value
  }

}

public enum _HStackElementNode: _StackElementNodeType {

  case content(_HStackItem)
  case spacer(StackingSpacer)

  var _content: _HStackItem? {
    guard case .content(let value) = self else {
      return nil
    }
    return value
  }

  var _spacer: StackingSpacer? {
    guard case .spacer(let value) = self else {
      return nil
    }
    return value
  }

}

public protocol StackItemType {
  var spacingBefore: CGFloat? { get }
  var spacingAfter: CGFloat? { get }
  var isEnabled: Bool { get }
}

public protocol _VStackItemConvertible {
  var _vStackItem: _VStackItem { get }
}

public protocol _HStackItemConvertible {
  var _hStackItem: _HStackItem { get }
}

public struct _VStackItem: _VStackItemConvertible, StackItemType {

  public var _vStackItem: _VStackItem { self }

  public let node: _LayoutBlockNode
  public var alignSelf: VStackBlock.XAxisAlignment? = nil
  public var spacingBefore: CGFloat? = nil
  public var spacingAfter: CGFloat? = nil
  public var isEnabled: Bool = true

}

public struct _HStackItem: _HStackItemConvertible, StackItemType {

  public var _hStackItem: _HStackItem { self }

  public let node: _LayoutBlockNode
  public var alignSelf: HStackBlock.YAxisAlignment? = nil
  public var spacingBefore: CGFloat? = nil
  public var spacingAfter: CGFloat? = nil
  public var isEnabled: Bool  = true

}

extension _VStackItemConvertible {

  public func alignSelf(_ alignment: VStackBlock.XAxisAlignment) -> _VStackItem {
    var item = _vStackItem
    item.alignSelf = alignment
    return item
  }

  public func spacingBefore(_ spacing: CGFloat) -> _VStackItem {
    var item = _vStackItem
    item.spacingBefore = (item.spacingBefore ?? 0) + spacing
    return item
  }

  public func spacingAfter(_ spacing: CGFloat) -> _VStackItem {
    var item = _vStackItem
    item.spacingAfter = (item.spacingAfter ?? 0) + spacing
    return item
  }

  public func isEnabled(_ isEnabled: Bool) -> _VStackItem {
    var item = _vStackItem
    item.isEnabled = isEnabled
    return item
  }
}

extension _HStackItemConvertible {

  public func alignSelf(_ alignment: HStackBlock.YAxisAlignment) -> _HStackItem {
    var item = _hStackItem
    item.alignSelf = alignment
    return item
  }

  public func spacingBefore(_ spacing: CGFloat) -> _HStackItem {
    var item = _hStackItem
    item.spacingBefore = (item.spacingBefore ?? 0) + spacing
    return item
  }

  public func spacingAfter(_ spacing: CGFloat) -> _HStackItem {
    var item = _hStackItem
    item.spacingAfter = (item.spacingAfter ?? 0) + spacing
    return item
  }

  public func isEnabled(_ isEnabled: Bool) -> _HStackItem {
    var item = _hStackItem
    item.isEnabled = isEnabled
    return item
  }
}

@resultBuilder
public enum VStackContentBuilder {
  public typealias Component = _VStackElementNode

  public static func buildBlock() -> [Component] {
    return []
  }

  public static func buildBlock(_ nestedComponents: [Component]...) -> [Component] {
    return nestedComponents.flatMap { $0 }
  }

  public static func buildExpression(_ layoutGuides: [UILayoutGuide]...) -> [Component] {
    return layoutGuides.flatMap { $0 }.map {
      .content(.init(node: .layoutGuide(.init($0))))
    }
  }

  public static func buildExpression<LayoutGuide: UILayoutGuide>(_ layoutGuide: LayoutGuide) -> [Component] {
    return [
      .content(.init(node: .layoutGuide(.init(layoutGuide))))
    ]
  }

  public static func buildExpression<LayoutGuide: UILayoutGuide>(_ layoutGuide: LayoutGuide?) -> [Component] {
    guard let view = layoutGuide else { return [] }
    return buildExpression(view)
  }

  public static func buildExpression(_ views: [UIView]...) -> [Component] {
    return views.flatMap { $0 }.map {
      .content(.init(node: .view(.init($0))))
    }
  }

  public static func buildExpression<View: UIView>(_ view: View) -> [Component] {
    return [
      .content(.init(node: .view(.init(view))))
    ]
  }

  public static func buildExpression<View: UIView>(_ view: View?) -> [Component] {
    guard let view = view else { return [] }
    return buildExpression(view)
  }

  public static func buildExpression<Block: _VStackItemConvertible>(
    _ block: Block
  ) -> [Component] {
    let item = block._vStackItem
    return item.isEnabled ? [.content(item)] : []
  }

  public static func buildExpression(_ blocks: [_VStackItemConvertible]...) -> [Component] {
    return blocks.flatMap { $0 }.compactMap {
      let item = $0._vStackItem
      return item.isEnabled ? .content(item) : nil
    }
  }

  public static func buildExpression(_ spacer: StackingSpacer) -> [Component] {
    return [.spacer(spacer)]
  }

}

@resultBuilder
public enum HStackContentBuilder {
  public typealias Component = _HStackElementNode

  public static func buildBlock(_ nestedComponents: [Component]...) -> [Component] {
    return nestedComponents.flatMap { $0 }
  }

  public static func buildExpression(_ views: [UIView]...) -> [Component] {
    return views.flatMap { $0 }.map {
      .content(.init(node: .view(.init($0))))
    }
  }

  public static func buildExpression<View: UIView>(_ view: View) -> [Component] {
    return [
      .content(.init(node: .view(.init(view))))
    ]
  }

  public static func buildExpression<View: UIView>(_ view: View?) -> [Component] {
    guard let view = view else { return [] }
    return buildExpression(view)
  }

  public static func buildExpression<Block: _HStackItemConvertible>(
    _ block: Block
  ) -> [Component] {
    let item = block._hStackItem
    return item.isEnabled ? [.content(item)] : []
  }

  public static func buildExpression(_ blocks: [_HStackItemConvertible]...) -> [Component] {
    return blocks.flatMap { $0 }.compactMap {
      let item = $0._hStackItem
      return item.isEnabled ? .content(item) : nil
    }
  }


  public static func buildExpression(_ spacer: StackingSpacer) -> [Component] {
    return [.spacer(spacer)]
  }

}
