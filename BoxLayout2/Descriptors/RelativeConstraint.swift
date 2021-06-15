import UIKit

public enum _RelativeContent {

  case view(ViewConstraint)
  case vStack(VStackConstraint)
  case hStack(HStackConstraint)
  case zStack(ZStackConstraint)
  case overlay(OverlayConstraint)
  case background(BackgroundConstraint)
}

public typealias PaddingConstraint = RelativeConstraint
public struct RelativeConstraint: LayoutDescriptorType, _BackgroundContentConvertible,
  _OverlayContentConvertible
{

  public var _backgroundContent: _BackgroundContent {
    return .relative(self)
  }

  public var _overlayContent: _OverlayContent {
    return .relative(self)
  }

  public let content: _RelativeContent

  public var top: CGFloat?
  public var bottom: CGFloat?
  public var right: CGFloat?
  public var left: CGFloat?

  init(
    top: CGFloat? = nil,
    left: CGFloat? = nil,
    bottom: CGFloat? = nil,
    right: CGFloat? = nil,
    @RelativeContentBuilder content: () -> _RelativeContent
  ) {

    self.top = top
    self.left = left
    self.bottom = bottom
    self.right = right
    self.content = content()
  }

  public func setupConstraints(parent: _LayoutElement, in context: Context) {

    func perform(current: _LayoutElement) {

      context.add(
        constraints: [
          top.map {
            current.topAnchor.constraint(equalTo: parent.topAnchor, constant: $0)
          },
          right.map {
            current.rightAnchor.constraint(equalTo: parent.rightAnchor, constant: -$0)
          },
          left.map {
            current.leftAnchor.constraint(equalTo: parent.leftAnchor, constant: $0)
          },
          bottom.map {
            current.bottomAnchor.constraint(equalTo: parent.bottomAnchor, constant: -$0)
          },
        ].compactMap { $0 }
      )

      context.add(
        constraints: [
          current.leftAnchor.constraint(greaterThanOrEqualTo: parent.leftAnchor),
          current.topAnchor.constraint(greaterThanOrEqualTo: parent.topAnchor),
          current.rightAnchor.constraint(lessThanOrEqualTo: parent.rightAnchor),
          current.bottomAnchor.constraint(lessThanOrEqualTo: parent.bottomAnchor),
        ]
      )

      if top != nil, right != nil, left != nil, bottom != nil {
        context.add(
          constraints: [
            current.centerXAnchor.constraint(equalTo: parent.centerXAnchor).withPriority(
              .defaultHigh
            ),
            current.centerYAnchor.constraint(equalTo: parent.centerYAnchor).withPriority(
              .defaultHigh
            ),
          ]
        )
      }

    }

    switch content {
    case .view(let viewConstarint):

      context.register(view: viewConstarint)

      perform(current: .init(view: viewConstarint.view))

    case .vStack(let c):

      let newLayoutGuide = context.makeLayoutGuide(identifier: "RelativeConstraint.VStack")
      c.setupConstraints(parent: .init(layoutGuide: newLayoutGuide), in: context)
      perform(current: .init(layoutGuide: newLayoutGuide))

    case .hStack(let c):

      let newLayoutGuide = context.makeLayoutGuide(identifier: "RelativeConstraint.HStack")
      c.setupConstraints(parent: .init(layoutGuide: newLayoutGuide), in: context)
      perform(current: .init(layoutGuide: newLayoutGuide))

    case .zStack(let c):

      let newLayoutGuide = context.makeLayoutGuide(identifier: "RelativeConstraint.ZStack")
      c.setupConstraints(parent: .init(layoutGuide: newLayoutGuide), in: context)
      perform(current: .init(layoutGuide: newLayoutGuide))

    case .background(let c):

      let newLayoutGuide = context.makeLayoutGuide(identifier: "RelativeConstraint.Background")
      c.setupConstraints(parent: .init(layoutGuide: newLayoutGuide), in: context)
      perform(current: .init(layoutGuide: newLayoutGuide))

    case .overlay(let c):

      let newLayoutGuide = context.makeLayoutGuide(identifier: "RelativeConstraint.Overlay")
      c.setupConstraints(parent: .init(layoutGuide: newLayoutGuide), in: context)
      perform(current: .init(layoutGuide: newLayoutGuide))

    }

  }

}

@_functionBuilder
public enum RelativeContentBuilder {
  public typealias Component = _RelativeContent
}

extension RelativeContentBuilder {

  public static func buildBlock(_ components: _RelativeContent) -> Component {
    return components
  }

  public static func buildExpression<View: UIView>(_ view: View) -> Component {
    return .view(.init(view))
  }

  public static func buildExpression(_ stack: VStackConstraint) -> Component {
    return .vStack(stack)
  }

  public static func buildExpression(_ stack: HStackConstraint) -> Component {
    return .hStack(stack)
  }

  public static func buildExpression(_ stack: ZStackConstraint) -> Component {
    return .zStack(stack)
  }

  public static func buildExpression(_ view: ViewConstraint) -> Component {
    return .view(view)
  }

  public static func buildExpression(_ components: _RelativeContent) -> Component {
    return components
  }
}

public protocol _RelativeContentConvertible {

  var _relativeContent: _RelativeContent {
    get
  }
}

extension _RelativeContentConvertible {

  public func relative(
    top: CGFloat? = nil,
    left: CGFloat? = nil,
    bottom: CGFloat? = nil,
    right: CGFloat? = nil
  ) -> RelativeConstraint {
    return .init(top: top, left: left, bottom: bottom, right: right) {
      self._relativeContent
    }
  }

  // MARK: - Modifiers
  private func padding(
    top: CGFloat,
    left: CGFloat,
    bottom: CGFloat,
    right: CGFloat
  ) -> RelativeConstraint {
    return .init(top: top, left: left, bottom: bottom, right: right) {
      self._relativeContent
    }
  }

  public func padding(_ value: CGFloat) -> RelativeConstraint {
    return padding(top: value, left: value, bottom: value, right: value)
  }

  public func padding(_ edgeInsets: UIEdgeInsets) -> RelativeConstraint {
    return padding(
      top: edgeInsets.top,
      left: edgeInsets.left,
      bottom: edgeInsets.bottom,
      right: edgeInsets.right
    )
  }

  public func padding(_ edges: Edge.Set, _ value: CGFloat) -> RelativeConstraint {

    return padding(
      top: edges.contains(.top) ? value : 0,
      left: edges.contains(.left) ? value : 0,
      bottom: edges.contains(.bottom) ? value : 0,
      right: edges.contains(.right) ? value : 0
    )

  }

}
