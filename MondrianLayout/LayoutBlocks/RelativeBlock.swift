import UIKit

/// [MondrianLayout]
/// A descriptor that lays out a single content and positions within the parent according to vertical and horizontal positional length.
public struct RelativeBlock: _LayoutBlockType, _LayoutBlockNodeConvertible {

  public struct ConstrainedValue: Equatable {
    public var min: CGFloat?
    public var exact: CGFloat?
    public var max: CGFloat?

    var isEmpty: Bool {
      return min == nil && exact == nil && max == nil
    }

    var isExactOnly: Bool {
      return exact != nil && min == nil && max == nil
    }

    public init(
      min: CGFloat? = nil,
      exact: CGFloat? = nil,
      max: CGFloat? = nil
    ) {
      self.min = min
      self.exact = exact
      self.max = max
    }

    public mutating func accumulate(keyPath: WritableKeyPath<Self, CGFloat?>, _ other: CGFloat?) {
      self[keyPath: keyPath] =
        other.map { (self[keyPath: keyPath] ?? 0) + $0 } ?? self[keyPath: keyPath]
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

  var top: ConstrainedValue = .init()
  var bottom: ConstrainedValue = .init()
  var trailing: ConstrainedValue = .init()
  var leading: ConstrainedValue = .init()

  init(
    top: CGFloat? = nil,
    leading: CGFloat? = nil,
    bottom: CGFloat? = nil,
    trailing: CGFloat? = nil,
    content: () -> _LayoutBlockNode
  ) {

    self.top.exact = top
    self.leading.exact = leading
    self.bottom.exact = bottom
    self.trailing.exact = trailing
    self.content = content()
  }

  public func setupConstraints(parent: _LayoutElement, in context: LayoutBuilderContext) {

    func perform(current: _LayoutElement) {

      var proposedConstraints: [NSLayoutConstraint] = []

      // setting up constraints according to values

      proposedConstraints +=
        ([
          top.exact.map {
            current.topAnchor.constraint(equalTo: parent.topAnchor, constant: $0)
          },
          trailing.exact.map {
            current.trailingAnchor.constraint(equalTo: parent.trailingAnchor, constant: -$0)
          },
          leading.exact.map {
            current.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: $0)
          },
          bottom.exact.map {
            current.bottomAnchor.constraint(equalTo: parent.bottomAnchor, constant: -$0)
          },

          top.min.map {
            current.topAnchor.constraint(greaterThanOrEqualTo: parent.topAnchor, constant: $0)
          },
          trailing.min.map {
            current.trailingAnchor.constraint(lessThanOrEqualTo: parent.trailingAnchor, constant: -$0)
          },
          leading.min.map {
            current.leadingAnchor.constraint(greaterThanOrEqualTo: parent.leadingAnchor, constant: $0)
          },
          bottom.min.map {
            current.bottomAnchor.constraint(lessThanOrEqualTo: parent.bottomAnchor, constant: -$0)
          },

          top.max.map {
            current.topAnchor.constraint(lessThanOrEqualTo: parent.topAnchor, constant: $0)
          },
          trailing.max.map {
            current.trailingAnchor.constraint(greaterThanOrEqualTo: parent.trailingAnchor, constant: -$0)
          },
          leading.max.map {
            current.leadingAnchor.constraint(lessThanOrEqualTo: parent.leadingAnchor, constant: $0)
          },
          bottom.max.map {
            current.bottomAnchor.constraint(greaterThanOrEqualTo: parent.bottomAnchor, constant: -$0)
          },

        ] as [NSLayoutConstraint?]).compactMap { $0 }

      constraintsToFitInsideContainer: do {

        /**
         If a edge does not have minimum or exact value, the element might be overflowed.
         */

        if bottom.min == nil, bottom.exact == nil {
          proposedConstraints.append(
            current.bottomAnchor.constraint(lessThanOrEqualTo: parent.bottomAnchor)
          )
        }

        if top.min == nil, top.exact == nil {
          proposedConstraints.append(
            current.topAnchor.constraint(greaterThanOrEqualTo: parent.topAnchor)
          )
        }

        if leading.min == nil, leading.exact == nil {
          proposedConstraints.append(
            current.trailingAnchor.constraint(lessThanOrEqualTo: parent.trailingAnchor)
          )
        }

        if trailing.min == nil, trailing.exact == nil {
          proposedConstraints.append(
            current.trailingAnchor.constraint(lessThanOrEqualTo: parent.trailingAnchor)
          )
        }

      }

      constraintsToPositionCenter: do {

        /**
         Vertically or horizontally, if there are no specifiers, that causes an ambiguous layout.
         As a default behavior, in that case, adds centering layout constraints.
         */

        vertical: do {
          if [bottom, top].allSatisfy({ $0.min == nil && $0.exact == nil }) {
            proposedConstraints.append(
              current.centerYAnchor.constraint(equalTo: parent.centerYAnchor).setPriority(
                .defaultHigh
              )
            )
          }
        }

        horizontal: do {
          if [leading, trailing].allSatisfy({ $0.min == nil && $0.exact == nil }) {
            proposedConstraints.append(
              current.centerXAnchor.constraint(equalTo: parent.centerXAnchor).setPriority(
                .defaultHigh
              )
            )
          }
        }

      }

      proposedConstraints.forEach {
        $0.setInternalIdentifier(name)
      }

      context.add(constraints: proposedConstraints)

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
    leading: CGFloat? = nil,
    bottom: CGFloat? = nil,
    trailing: CGFloat? = nil
  ) -> RelativeBlock {

    if case .relative(let relativeBlock) = self._layoutBlockNode {
      var new = relativeBlock

      new.top.accumulate(keyPath: \.exact, top)
      new.leading.accumulate(keyPath: \.exact, leading)
      new.trailing.accumulate(keyPath: \.exact, trailing)
      new.bottom.accumulate(keyPath: \.exact, bottom)

      return new
    } else {
      return .init(top: top, leading: leading, bottom: bottom, trailing: trailing) {
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
    return relative(top: value, leading: value, bottom: value, trailing: value)
  }

  /**
   `.relative` modifier describes that the content attaches to specified edges with padding.
   Not specified edges do not have constraints to the edge. so the sizing depends on intrinsic content size.

   You might use this modifier to pin to edge as an overlay content.
   */
  public func relative(_ edgeInsets: UIEdgeInsets) -> RelativeBlock {
    return relative(
      top: edgeInsets.top,
      leading: edgeInsets.left,
      bottom: edgeInsets.bottom,
      trailing: edgeInsets.right
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
      leading: edges.contains(.leading) ? value : nil,
      bottom: edges.contains(.bottom) ? value : nil,
      trailing: edges.contains(.trailing) ? value : nil
    )

  }

  /**
   .padding modifier is similar with .relative but something different.
   Different with that, Not specified edges pin to edge with 0 padding.
   */
  private func padding(
    top: CGFloat,
    leading: CGFloat,
    bottom: CGFloat,
    trailing: CGFloat
  ) -> RelativeBlock {

    if case .relative(let relativeBlock) = self._layoutBlockNode {
      var new = relativeBlock

      new.top.accumulate(keyPath: \.exact, top)
      new.leading.accumulate(keyPath: \.exact, leading)
      new.trailing.accumulate(keyPath: \.exact, trailing)
      new.bottom.accumulate(keyPath: \.exact, bottom)

      return new
    } else {
      return .init(top: top, leading: leading, bottom: bottom, trailing: trailing) {
        self._layoutBlockNode
      }
    }

  }

  /**
   .padding modifier is similar with .relative but something different.
   Different with that, Not specified edges pin to edge with 0 padding.
   */
  public func padding(_ value: CGFloat) -> RelativeBlock {
    return padding(top: value, leading: value, bottom: value, trailing: value)
  }

  /**
   .padding modifier is similar with .relative but something different.
   Different with that, Not specified edges pin to edge with 0 padding.
   */
  public func padding(_ edgeInsets: UIEdgeInsets) -> RelativeBlock {
    return padding(
      top: edgeInsets.top,
      leading: edgeInsets.left,
      bottom: edgeInsets.bottom,
      trailing: edgeInsets.right
    )
  }

  /**
   .padding modifier is similar with .relative but something different.
   Different with that, Not specified edges pin to edge with 0 padding.
   */
  public func padding(_ edges: Edge.Set, _ value: CGFloat) -> RelativeBlock {

    return padding(
      top: edges.contains(.top) ? value : 0,
      leading: edges.contains(.leading) ? value : 0,
      bottom: edges.contains(.bottom) ? value : 0,
      trailing: edges.contains(.trailing) ? value : 0
    )

  }

}
