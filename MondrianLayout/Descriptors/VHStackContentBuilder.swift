import UIKit

public enum _VHStackContent {

  case view(ViewBlock)
  case relative(RelativeBlock)
  case spacer(SpacerBlock)
  case vStack(VStackBlock)
  case hStack(HStackBlock)
  case zStack(ZStackBlock)
  case background(BackgroundBlock)
  case overlay(OverlayBlock)

}

public struct _VStackItem {

  public let content: _VHStackContent
  public var alignSelf: VStackBlock.HorizontalAlignment?
}

public struct _HStackItem {

  public let content: _VHStackContent
  public var alignSelf: HStackBlock.VerticalAlignment?

}

public protocol _VHStackItemContentConvertible {
  var vhStackItemContent: _VHStackContent { get }
}

extension _VHStackItemContentConvertible {

  public func alignSelf(_ alignment: VStackBlock.HorizontalAlignment) -> _VStackItem {
    var item = _VStackItem(content: vhStackItemContent)
    item.alignSelf = alignment
    return item
  }

  public func alignSelf(_ alignment: HStackBlock.VerticalAlignment) -> _HStackItem {
    var item = _HStackItem(content: vhStackItemContent)
    item.alignSelf = alignment
    return item
  }

  public func spacingBefore(_ spacing: CGFloat) -> [_VStackItem] {
    return [
      .init(content: .spacer(SpacerBlock(minLength: spacing, expands: false)), alignSelf: nil),
      .init(content: self.vhStackItemContent, alignSelf: nil),
    ]
  }

  public func spacingAfter(_ spacing: CGFloat) -> [_VStackItem] {
    return [
      .init(content: self.vhStackItemContent, alignSelf: nil),
      .init(content: .spacer(SpacerBlock(minLength: spacing, expands: false)), alignSelf: nil),
    ]
  }

  public func spacingBefore(_ spacing: CGFloat) -> [_HStackItem] {
    return [
      .init(content: .spacer(SpacerBlock(minLength: spacing, expands: false)), alignSelf: nil),
      .init(content: self.vhStackItemContent, alignSelf: nil),
    ]
  }

  public func spacingAfter(_ spacing: CGFloat) -> [_HStackItem] {
    return [
      .init(content: self.vhStackItemContent, alignSelf: nil),
      .init(content: .spacer(SpacerBlock(minLength: spacing, expands: false)), alignSelf: nil),
    ]
  }

}

extension ViewBlock: _VHStackItemContentConvertible {
  public var vhStackItemContent: _VHStackContent {
    return .view(self)
  }
}

extension RelativeBlock: _VHStackItemContentConvertible {
  public var vhStackItemContent: _VHStackContent {
    return .relative(self)
  }
}

extension VStackBlock: _VHStackItemContentConvertible {
  public var vhStackItemContent: _VHStackContent {
    return .vStack(self)
  }
}

extension HStackBlock: _VHStackItemContentConvertible {
  public var vhStackItemContent: _VHStackContent {
    return .hStack(self)
  }
}

extension ZStackBlock: _VHStackItemContentConvertible {
  public var vhStackItemContent: _VHStackContent {
    return .zStack(self)
  }
}

extension BackgroundBlock: _VHStackItemContentConvertible {
  public var vhStackItemContent: _VHStackContent {
    return .background(self)
  }
}

extension OverlayBlock: _VHStackItemContentConvertible {
  public var vhStackItemContent: _VHStackContent {
    return .overlay(self)
  }
}

@_functionBuilder
public enum VStackContentBuilder {
  public typealias Component = _VStackItem

  public static func buildBlock(_ nestedComponents: [Component]...) -> [Component] {
    nestedComponents.flatMap { $0 }
  }

  public static func buildExpression(_ views: [UIView]...) -> [Component] {
    views.flatMap { $0 }.map { .init(content: .view(.init($0)), alignSelf: nil)}
  }

  public static func buildExpression<View: UIView>(_ view: View) -> [Component] {
    return [.init(content: .view(.init(view)))]
  }

  public static func buildExpression(_ item: Component) -> [Component] {
    return [item]
  }

  public static func buildExpression<Source: _VHStackItemContentConvertible>(_ source: Source) -> [Component] {
    return [.init(content: source.vhStackItemContent)]
  }

  public static func buildExpression(_ source: [_VHStackItemContentConvertible]...) -> [Component] {
    source.flatMap { $0 }.map { .init(content: $0.vhStackItemContent) }
  }

  public static func buildExpression(_ source: [Component]...) -> [Component] {
    source.flatMap { $0 }
  }

  public static func buildExpression(_ spacer: SpacerBlock) -> [Component] {
    return [.init(content: .spacer(spacer))]
  }

}

@_functionBuilder
public enum HStackContentBuilder {
  public typealias Component = _HStackItem

  public static func buildBlock(_ nestedComponents: [Component]...) -> [Component] {
    nestedComponents.flatMap { $0 }
  }

  public static func buildExpression(_ views: [UIView]...) -> [Component] {
    views.flatMap { $0 }.map { .init(content: .view(.init($0)), alignSelf: nil)}
  }

  public static func buildExpression<View: UIView>(_ view: View) -> [Component] {
    return [.init(content: .view(.init(view)))]
  }

  public static func buildExpression(_ item: Component) -> [Component] {
    return [item]
  }

  public static func buildExpression<Source: _VHStackItemContentConvertible>(_ source: Source) -> [Component] {
    return [.init(content: source.vhStackItemContent)]
  }

  public static func buildExpression(_ source: [_VHStackItemContentConvertible]...) -> [Component] {
    source.flatMap { $0 }.map { .init(content: $0.vhStackItemContent) }
  }

  public static func buildExpression(_ source: [Component]...) -> [Component] {
    source.flatMap { $0 }
  }

  public static func buildExpression(_ spacer: SpacerBlock) -> [Component] {
    return [.init(content: .spacer(spacer))]
  }
}

struct DistributingState {

  var hasStartedLayout = false
  var initialSpace: SpacerBlock = .init(minLength: 0, expands: false)
  var previous: _LayoutElement?
  private(set) var spaceToPrevious: [SpacerBlock] = []
  var currentLayoutElement: _LayoutElement!

  mutating func appendSpacer(_ block: SpacerBlock) {
    spaceToPrevious.append(block)
  }

  mutating func resetSpacingInterItem(_ block: SpacerBlock) {
    spaceToPrevious = [block]
  }

  func totalSpace() -> CGFloat {
    spaceToPrevious.reduce(0) { space, block in
      space + block.minLength
    }
  }

  func isEpandableSpace() -> Bool {
    spaceToPrevious.contains(where: { $0.expands == true })
  }
}
