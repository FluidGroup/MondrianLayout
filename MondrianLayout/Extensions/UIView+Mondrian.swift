import UIKit

@resultBuilder
public enum EntrypointBuilder {

  public enum Either {
    case block(_LayoutBlockType)
    case container(LayoutContainer)
  }

  public static func buildBlock(_ components: [Either]...) -> [Either] {
    return components.flatMap { $0 }
  }

  public static func buildExpression<Block: _LayoutBlockType>(_ components: Block...) -> [Either] {
    return components.map { .block($0) }
  }

  public static func buildExpression(_ components: LayoutContainer...) -> [EntrypointBuilder.Either] {
    return components.map { .container($0) }
  }

}

extension MondrianNamespace where Base : UIView {

  /**
   Builds subviews of this view.
   - activating layout-constraints
   - adding layout-guides
   - applying content-hugging, content-compression-resistance

   You can start to describe like followings:

   ```swift
   view.mondrian.buildSubviews {
     ZStackBlock {
       ...
     }
   }
   ```

   ```swift
   view.mondrian.buildSubviews {
     LayoutContainer(attachedSafeAreaEdges: .vertical) {
       ...
     }
   }
   ```


   ```swift
   view.mondrian.buildSubviews {
     LayoutContainer(attachedSafeAreaEdges: .vertical) {
       ...
     }
     ZStackBlock {
       ...
     }
   }
   ```
   */
  @discardableResult
  public func buildSubviews(@EntrypointBuilder _ build: () -> [EntrypointBuilder.Either]) -> LayoutBuilderContext {

    let entrypoints = build()

    let context = LayoutBuilderContext(targetView: base)

    for entrypoint in entrypoints {
      switch entrypoint {
      case .block(let block):
        block.setupConstraints(parent: .init(view: base), in: context)
      case .container(let container):
        container.setupConstraints(parent: base, in: context)
      }
    }

    context.prepareViewHierarchy()
    context.activate()

    return context
  }

  /// Applies the layout of the dimension in itself.
  public func buildSelfSizing(build: (ViewBlock) -> ViewBlock) {

    let constraint = ViewBlock(base)
    let modifiedConstraint = build(constraint)

    modifiedConstraint.makeApplier()()
    NSLayoutConstraint.activate(
      modifiedConstraint.makeConstraints()
    )

  }

}

extension UIView {

  public var mondrian: MondrianNamespace<UIView> {
    return .init(base: self)
  }

}



extension UIView {

  /// Returns an instance of ViewBlock to describe layout.
  public var viewBlock: ViewBlock {
    .init(self)
  }

  public var hasAmbiguousLayoutRecursively: Bool {

    var hasAmbiguous: Bool = false

    func traverse(_ view: UIView) {

      if view.hasAmbiguousLayout {
        hasAmbiguous = true
      }

      for subview in view.subviews {
        traverse(subview)
      }

    }

    traverse(self)

    return hasAmbiguous
  }

}
