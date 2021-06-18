import UIKit

public typealias PaddingBlock = RelativeBlock
public struct RelativeBlock: _LayoutBlockType, _LayoutBlockNodeConvertible {

  public var name: String = "Relative"

  public var _layoutBlockNode: _LayoutBlockNode {
    return .relative(self)
  }

  public let content: _LayoutBlockNode

  public var top: CGFloat?
  public var bottom: CGFloat?
  public var right: CGFloat?
  public var left: CGFloat?

  init(
    top: CGFloat? = nil,
    left: CGFloat? = nil,
    bottom: CGFloat? = nil,
    right: CGFloat? = nil,
    content: () -> _LayoutBlockNode
  ) {

    self.top = top
    self.left = left
    self.bottom = bottom
    self.right = right
    self.content = content()
  }

  public func setupConstraints(parent: _LayoutElement, in context: LayoutBuilderContext) {

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

      context.register(viewConstraint: viewConstarint)

      perform(current: .init(view: viewConstarint.view))

    case .vStack(let c as _LayoutBlockType),
      .hStack(let c as _LayoutBlockType),
      .zStack(let c as _LayoutBlockType),
      .background(let c as _LayoutBlockType),
      .relative(let c as _LayoutBlockType),
      .overlay(let c as _LayoutBlockType):

      let newLayoutGuide = context.makeLayoutGuide(identifier: "RelativeBlock.\(c.name)")
      c.setupConstraints(parent: .init(layoutGuide: newLayoutGuide), in: context)
      perform(current: .init(layoutGuide: newLayoutGuide))

    }

  }

}

extension RelativeBlock {

  public func relative(
    top: CGFloat? = nil,
    left: CGFloat? = nil,
    bottom: CGFloat? = nil,
    right: CGFloat? = nil
  ) -> RelativeBlock {

    var new = self

    new.top = top.map { (new.top ?? 0) + $0 }
    new.left = left.map { (new.left ?? 0) + $0 }
    new.bottom = bottom.map { (new.bottom ?? 0) + $0 }
    new.right = right.map { (new.right ?? 0) + $0 }

    return new

  }

  public func relative(_ value: CGFloat) -> PaddingBlock {
    return relative(top: value, left: value, bottom: value, right: value)
  }

  public func relative(_ edgeInsets: UIEdgeInsets) -> PaddingBlock {
    return relative(
      top: edgeInsets.top,
      left: edgeInsets.left,
      bottom: edgeInsets.bottom,
      right: edgeInsets.right
    )
  }

  public func relative(_ edges: Edge.Set, _ value: CGFloat) -> PaddingBlock {

    return relative(
      top: edges.contains(.top) ? value : nil,
      left: edges.contains(.left) ? value : nil,
      bottom: edges.contains(.bottom) ? value : nil,
      right: edges.contains(.right) ? value : nil
    )

  }

  private func padding(
    top: CGFloat,
    left: CGFloat,
    bottom: CGFloat,
    right: CGFloat
  ) -> PaddingBlock {
    var new = self

    new.top = (new.top ?? 0) + (top)
    new.left = (new.left ?? 0) + (left)
    new.bottom = (new.bottom ?? 0) + (bottom)
    new.right = (new.right ?? 0) + (right)

    return new
  }

  public func padding(_ value: CGFloat) -> PaddingBlock {
    return padding(top: value, left: value, bottom: value, right: value)
  }

  public func padding(_ edgeInsets: UIEdgeInsets) -> PaddingBlock {
    return padding(
      top: edgeInsets.top,
      left: edgeInsets.left,
      bottom: edgeInsets.bottom,
      right: edgeInsets.right
    )
  }

  public func padding(_ edges: Edge.Set, _ value: CGFloat) -> PaddingBlock {

    return padding(
      top: edges.contains(.top) ? value : 0,
      left: edges.contains(.left) ? value : 0,
      bottom: edges.contains(.bottom) ? value : 0,
      right: edges.contains(.right) ? value : 0
    )

  }

}

extension _LayoutBlockNodeConvertible {

  public func relative(
    top: CGFloat? = nil,
    left: CGFloat? = nil,
    bottom: CGFloat? = nil,
    right: CGFloat? = nil
  ) -> RelativeBlock {
    return .init(top: top, left: left, bottom: bottom, right: right) {
      self._layoutBlockNode
    }
  }

  public func relative(_ value: CGFloat) -> PaddingBlock {
    return relative(top: value, left: value, bottom: value, right: value)
  }

  public func relative(_ edgeInsets: UIEdgeInsets) -> PaddingBlock {
    return relative(
      top: edgeInsets.top,
      left: edgeInsets.left,
      bottom: edgeInsets.bottom,
      right: edgeInsets.right
    )
  }

  public func relative(_ edges: Edge.Set, _ value: CGFloat) -> PaddingBlock {

    return relative(
      top: edges.contains(.top) ? value : nil,
      left: edges.contains(.left) ? value : nil,
      bottom: edges.contains(.bottom) ? value : nil,
      right: edges.contains(.right) ? value : nil
    )

  }

  private func padding(
    top: CGFloat,
    left: CGFloat,
    bottom: CGFloat,
    right: CGFloat
  ) -> PaddingBlock {
    return .init(top: top, left: left, bottom: bottom, right: right) {
      self._layoutBlockNode
    }
  }

  public func padding(_ value: CGFloat) -> PaddingBlock {
    return padding(top: value, left: value, bottom: value, right: value)
  }

  public func padding(_ edgeInsets: UIEdgeInsets) -> PaddingBlock {
    return padding(
      top: edgeInsets.top,
      left: edgeInsets.left,
      bottom: edgeInsets.bottom,
      right: edgeInsets.right
    )
  }

  public func padding(_ edges: Edge.Set, _ value: CGFloat) -> PaddingBlock {

    return padding(
      top: edges.contains(.top) ? value : 0,
      left: edges.contains(.left) ? value : 0,
      bottom: edges.contains(.bottom) ? value : 0,
      right: edges.contains(.right) ? value : 0
    )

  }

}
