import UIKit

public struct GridLayoutItem {

  /// The size in the minor axis of one or more rows or columns in a grid
  /// layout.
  public enum Size {
    /// A single item with the specified fixed size.
    case fixed(CGFloat)

    /// A single flexible item.
    ///
    /// The size of this item is the size of the grid with spacing and
    /// inflexible items removed, divided by the number of flexible items,
    /// clamped to the provided bounds.
    case flexible(minimum: CGFloat = 10, maximum: CGFloat = .infinity)
  }

  /// The size of the item, which is the width of a column item or the
  /// height of a row item.
  public var size: Size

  /// The spacing to the next item.
  public var spacing: CGFloat = 0

  public init(_ size: Size = .flexible(), spacing: CGFloat = 0) {
    self.size = size
    self.spacing = spacing
  }

}

public struct VGridBlock: _LayoutBlockType, _DimensionConstraintType {

  public var name: String = "VGridBlock"

  public var dimensionConstraints: DimensionDescriptor = .init()

  public var _layoutBlockNode: _LayoutBlockNode {
    return .vGrid(self)
  }

  public let elements: [VGridContentBuilder.Component]
  public let columnSettings: [GridLayoutItem]
  public let spacing: CGFloat

  public init(
    columns: [GridLayoutItem],
    spacing: CGFloat = 0,
    @VGridContentBuilder elements: () -> [VGridContentBuilder.Component]
  ) {

    self.elements = elements()
    self.columnSettings = columns
    self.spacing = spacing
  }

  public func setupConstraints(parent: _LayoutElement, in context: LayoutBuilderContext) {

    context.add(constraints: dimensionConstraints.makeConstraints(for: parent))

    let columnCount = columnSettings.count

    guard columnCount > 0 else {
      return
    }

    /**
     Adds padding layout specs to display as grid
     */
    let v = elements.count % columnCount
    let emptyBlocks: [VGridContentBuilder.Component] = v >= 1 ? (0..<(columnCount - v)).map { _ in .layoutGuide(.init(UILayoutGuide())) } : []

    let rows = (elements + emptyBlocks)
      .chunked(into: columnCount)
      .map { $0 }

    var layoutGuidesBuffer: [[UILayoutGuide?]] = .init(repeating: .init(repeating: nil, count: columnCount), count: rows.count)

    for (rowIndex, row) in rows.enumerated() {

      for (columnIndex) in row.indices {

        let elementInRow = row[columnIndex]
        let normalizedColumnIndex = columnIndex - row.startIndex

        let columnSetting = columnSettings[normalizedColumnIndex]
        let layoutGuide = context.makeLayoutGuide(identifier: "VGrid-\(rowIndex)-\(columnIndex)")

        layoutGuidesBuffer[rowIndex][normalizedColumnIndex] = layoutGuide

        context.add(
          constraints: buildArray(type: NSLayoutConstraint.self) {

            if columnIndex == row.indices.startIndex {

              layoutGuide.leftAnchor.constraint(equalTo: parent.leftAnchor)

              if rowIndex > 0 {
                if let topSideLayoutGuide = layoutGuidesBuffer[rowIndex.advanced(by: -1)][normalizedColumnIndex] {
                  layoutGuide.topAnchor.constraint(equalTo: topSideLayoutGuide.bottomAnchor, constant: spacing)
                }
              }

            } else if columnIndex == row.indices.endIndex.advanced(by: -1) {

              let previousColumnSetting = columnSettings[normalizedColumnIndex.advanced(by: -1)]

              layoutGuide.rightAnchor.constraint(equalTo: parent.rightAnchor)

              if let leftSideLayoutGuide = layoutGuidesBuffer[rowIndex][normalizedColumnIndex.advanced(by: -1)] {
                layoutGuide.leftAnchor.constraint(equalTo: leftSideLayoutGuide.rightAnchor, constant: previousColumnSetting.spacing)
                layoutGuide.heightAnchor.constraint(equalTo: leftSideLayoutGuide.heightAnchor)
              }

              if rowIndex > 0 {
                if let topSideLayoutGuide = layoutGuidesBuffer[rowIndex.advanced(by: -1)][normalizedColumnIndex] {
                  layoutGuide.topAnchor.constraint(equalTo: topSideLayoutGuide.bottomAnchor, constant: spacing)
                }
              }

            } else {

              let previousColumnSetting = columnSettings[normalizedColumnIndex.advanced(by: -1)]

              if let leftSideLayoutGuide = layoutGuidesBuffer[rowIndex][normalizedColumnIndex.advanced(by: -1)] {
                layoutGuide.leftAnchor.constraint(equalTo: leftSideLayoutGuide.rightAnchor, constant: previousColumnSetting.spacing)
                layoutGuide.heightAnchor.constraint(equalTo: leftSideLayoutGuide.heightAnchor)
              }

              if rowIndex > 0 {
                if let topSideLayoutGuide = layoutGuidesBuffer[rowIndex.advanced(by: -1)][normalizedColumnIndex] {
                  layoutGuide.topAnchor.constraint(equalTo: topSideLayoutGuide.bottomAnchor, constant: spacing)
                }
              }
            }

          }
        )

        switch columnSetting.size {
        case .fixed(let length):

          context.add(constraints: [layoutGuide.widthAnchor.constraint(equalToConstant: length)])

        case .flexible(let minimum, let maximum):

          context.add(constraints: [
            layoutGuide.widthAnchor.constraint(greaterThanOrEqualToConstant: minimum),
            layoutGuide.widthAnchor.constraint(lessThanOrEqualToConstant: maximum.isInfinite ? .greatestFiniteMagnitude : maximum),
          ])
        }

        switch elementInRow {
        case .view(let viewBlock):
          context.register(viewBlock: viewBlock)
          context.add(constraints: viewBlock.makeConstraintsToEdge(.init(layoutGuide: layoutGuide)))
        case .layoutGuide(let layoutGuideBlock):
          context.register(layoutGuideBlock: layoutGuideBlock)
          context.add(constraints: layoutGuideBlock.makeConstraintsToEdge(.init(layoutGuide: layoutGuide)))
        case .vStack(let c as _LayoutBlockType),
            .hStack(let c as _LayoutBlockType),
            .zStack(let c as _LayoutBlockType),
            .relative(let c as _LayoutBlockType),
            .overlay(let c as _LayoutBlockType),
            .background(let c as _LayoutBlockType),
            .vGrid(let c as _LayoutBlockType):
          c.setupConstraints(parent: .init(layoutGuide: layoutGuide), in: context)
        }

      }

    }

    /// expanding equally

    let flexibleIndexes = columnSettings
      .enumerated()
      .filter {
        if case .flexible = $0.1.size {
          return true
        } else {
          return false
        }
      }
      .map { $0.0 }

    layoutGuidesBuffer.forEach { row in

      let layoutGuides = flexibleIndexes
        .compactMap { row[$0] }

      let firstLayuotGuide = layoutGuides.first!

      layoutGuides.dropFirst()
        .compactMap { $0 }
        .forEach { layoutGuide in

        context.add(constraints: [
          layoutGuide.widthAnchor.constraint(equalTo: firstLayuotGuide.widthAnchor).setPriority(.init(rawValue: 999))
        ])

      }


    }

    /// finalize:
    layoutGuidesBuffer.first?
      .compactMap { $0 }
      .forEach { layoutGuide in

        context.add(constraints: [
          layoutGuide.topAnchor.constraint(equalTo: parent.topAnchor)
        ])

      }

    layoutGuidesBuffer.last?
      .compactMap { $0 }
      .forEach { layoutGuide in

        context.add(constraints: [
          layoutGuide.bottomAnchor.constraint(equalTo: parent.bottomAnchor)
        ])

      }

  }

}

extension Collection where Index == Int {

  fileprivate func chunked(into size: Index) -> [Self.SubSequence] {
    stride(from: 0, to: count, by: size).map {
      self[$0 ..< Swift.min($0 + size, count)]
    }
  }

}

@resultBuilder
public enum VGridContentBuilder {
  public typealias Component = _LayoutBlockNode

  public static func buildBlock() -> [Component] {
    return []
  }

  public static func buildBlock(_ nestedComponents: [Component]...) -> [Component] {
    return nestedComponents.flatMap { $0 }
  }

  public static func buildOptional(_ component: [Component]?) -> [Component] {
    return component ?? []
  }

  public static func buildEither(first component: [Component]) -> [Component] {
    return component
  }

  public static func buildEither(second component: [Component]) -> [Component] {
    return component
  }

  public static func buildExpression(_ views: [UIView]...) -> [Component] {
    return views.flatMap { $0 }.map {
      return .view(.init($0))
    }
  }

  public static func buildExpression<View: UIView>(_ view: View) -> [Component] {
    return [
      .view(.init(view))
    ]
  }

  public static func buildExpression<View: UIView>(_ view: View?) -> [Component] {
    guard let view = view else { return [] }
    return buildExpression(view)
  }

  public static func buildExpression<Block: _LayoutBlockNodeConvertible>(
    _ block: Block
  ) -> [Component] {
    return [block._layoutBlockNode]
  }

  public static func buildExpression(_ blocks: [_LayoutBlockNodeConvertible]...) -> [Component] {
    return blocks.flatMap { $0 }.map { $0._layoutBlockNode }
  }

}
