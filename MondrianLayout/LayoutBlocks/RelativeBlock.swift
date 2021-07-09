import UIKit

/**
 [MondrianLayout]
 A descriptor that lays out a single content and positions within the parent according to vertical and horizontal positional length.
 */
public struct RelativeBlock: _LayoutBlockType, _LayoutBlockNodeConvertible {

  public struct ConstrainedValue: Equatable {
    public var min: CGFloat?
    public var exact: CGFloat?
    public var max: CGFloat?

    public init(min: CGFloat? = nil, exact: CGFloat? = nil, max: CGFloat? = nil) {
      self.min = min
      self.exact = exact
      self.max = max
    }

    public mutating func accumulate(keyPath: WritableKeyPath<Self, CGFloat?>, _ other: CGFloat?) {
      self[keyPath: keyPath] = other.map { (self[keyPath: keyPath] ?? 0) + $0 } ?? self[keyPath: keyPath]
    }

    public mutating func accumulate(_ other: Self) {
      accumulate(keyPath: \.min, other.min)
      accumulate(keyPath: \.exact, other.exact)
      accumulate(keyPath: \.max, other.max)
    }
  }

  public var name: String = "Relative"

  public var _layoutBlockNode: _LayoutBlockNode {
    return .relative(self)
  }

  public let content: _LayoutBlockNode

  public var top: ConstrainedValue = .init()
  public var bottom: ConstrainedValue = .init()
  public var right: ConstrainedValue = .init()
  public var left: ConstrainedValue = .init()
  
  init(
    top: CGFloat? = nil,
    left: CGFloat? = nil,
    bottom: CGFloat? = nil,
    right: CGFloat? = nil,
    content: () -> _LayoutBlockNode
  ) {

    self.top.exact = top
    self.left.exact = left
    self.bottom.exact = bottom
    self.right.exact = right
    self.content = content()
  }

  public func setupConstraints(parent: _LayoutElement, in context: LayoutBuilderContext) {

    func perform(current: _LayoutElement) {

      context.add(
        constraints: [
          top.exact.map {
            current.topAnchor.constraint(equalTo: parent.topAnchor, constant: $0)
          },
          right.exact.map {
            current.rightAnchor.constraint(equalTo: parent.rightAnchor, constant: -$0)
          },
          left.exact.map {
            current.leftAnchor.constraint(equalTo: parent.leftAnchor, constant: $0)
          },
          bottom.exact.map {
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

      if top.exact != nil, right.exact != nil, left.exact != nil, bottom.exact != nil {
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

extension _LayoutBlockNodeConvertible {

  /**
   `.relative` modifier describes that the content attaches to specified edges with padding.
   Not specified edges do not have constraints to the edge. so the sizing depends on intrinsic content size.

   You might use this modifier to pin to edge as an overlay content.

   ```swift
   ZStackBlock {
     VStackBlock {
       ...
     }
     .relative(bottom: 8, right: 8)
   }
   ```
   */
  private func relative(
    top: CGFloat? = nil,
    left: CGFloat? = nil,
    bottom: CGFloat? = nil,
    right: CGFloat? = nil
  ) -> RelativeBlock {

    if case .relative(let relativeBlock) = self._layoutBlockNode {
      var new = relativeBlock

      new.top.accumulate(keyPath: \.exact, top)
      new.left.accumulate(keyPath: \.exact, left)
      new.right.accumulate(keyPath: \.exact, right)
      new.bottom.accumulate(keyPath: \.exact, bottom)

      return new
    } else {
      return .init(top: top, left: left, bottom: bottom, right: right) {
        self._layoutBlockNode
      }
    }
  }

  /**
   `.relative` modifier describes that the content attaches to specified edges with padding.
   Not specified edges do not have constraints to the edge. so the sizing depends on intrinsic content size.

   You might use this modifier to pin to edge as an overlay content.
   */
  public func relative(_ value: CGFloat) -> RelativeBlock {
    return relative(top: value, left: value, bottom: value, right: value)
  }

  /**
   `.relative` modifier describes that the content attaches to specified edges with padding.
   Not specified edges do not have constraints to the edge. so the sizing depends on intrinsic content size.

   You might use this modifier to pin to edge as an overlay content.
   */
  public func relative(_ edgeInsets: UIEdgeInsets) -> RelativeBlock {
    return relative(
      top: edgeInsets.top,
      left: edgeInsets.left,
      bottom: edgeInsets.bottom,
      right: edgeInsets.right
    )
  }

  /**
   `.relative` modifier describes that the content attaches to specified edges with padding.
   Not specified edges do not have constraints to the edge. so the sizing depends on intrinsic content size.

   You might use this modifier to pin to edge as an overlay content.
   */
  public func relative(_ edges: Edge.Set, _ value: CGFloat) -> RelativeBlock {

    return relative(
      top: edges.contains(.top) ? value : nil,
      left: edges.contains(.leading) ? value : nil,
      bottom: edges.contains(.bottom) ? value : nil,
      right: edges.contains(.trailing) ? value : nil
    )

  }

  /**
   .padding modifier is similar with .relative but something different.
   Different with that, Not specified edges pin to edge with 0 padding.
   */
  private func padding(
    top: CGFloat,
    left: CGFloat,
    bottom: CGFloat,
    right: CGFloat
  ) -> RelativeBlock {

    if case .relative(let relativeBlock) = self._layoutBlockNode {
      var new = relativeBlock

      new.top.accumulate(keyPath: \.exact, top)
      new.left.accumulate(keyPath: \.exact, left)
      new.right.accumulate(keyPath: \.exact, right)
      new.bottom.accumulate(keyPath: \.exact, bottom)

      return new
    } else {
      return .init(top: top, left: left, bottom: bottom, right: right) {
        self._layoutBlockNode
      }
    }

  }

  /**
   .padding modifier is similar with .relative but something different.
   Different with that, Not specified edges pin to edge with 0 padding.
   */
  public func padding(_ value: CGFloat) -> RelativeBlock {
    return padding(top: value, left: value, bottom: value, right: value)
  }

  /**
   .padding modifier is similar with .relative but something different.
   Different with that, Not specified edges pin to edge with 0 padding.
   */
  public func padding(_ edgeInsets: UIEdgeInsets) -> RelativeBlock {
    return padding(
      top: edgeInsets.top,
      left: edgeInsets.left,
      bottom: edgeInsets.bottom,
      right: edgeInsets.right
    )
  }

  /**
   .padding modifier is similar with .relative but something different.
   Different with that, Not specified edges pin to edge with 0 padding.
   */
  public func padding(_ edges: Edge.Set, _ value: CGFloat) -> RelativeBlock {

    return padding(
      top: edges.contains(.top) ? value : 0,
      left: edges.contains(.leading) ? value : 0,
      bottom: edges.contains(.bottom) ? value : 0,
      right: edges.contains(.trailing) ? value : 0
    )

  }

}
