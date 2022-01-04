import UIKit

public enum Mondrian {

  @discardableResult
  public static func layout(
    @MondrianArrayBuilder<LayoutDescriptor> _ closure: () -> [LayoutDescriptor]
  ) -> ConstraintGroup {

    let descriptors = closure()

    let group = ConstraintGroup(constraints: [])

    descriptors.forEach {
      let g = $0.activate()
      group.append(g)
    }

    return group

  }

  /**
   Builds subviews of this view.
   - activating layout-constraints
   - adding layout-guides
   - applying content-hugging, content-compression-resistance

   You can start to describe like followings:

   ```swift
   Mondrian.buildSubviews(on: view) {
     ZStackBlock {
       ...
     }
   }
   ```

   ```swift
   Mondrian.buildSubviews(on: view) {
     LayoutContainer(attachedSafeAreaEdges: .vertical) {
       ...
     }
   }
   ```


   ```swift
   Mondrian.buildSubviews(on: view) {
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
  public static func buildSubviews(
    on view: UIView,
    @EntrypointBuilder _ build: () -> [EntrypointBuilder.Either]
  ) -> LayoutBuilderContext {

    let entrypoints = build()

    let context = LayoutBuilderContext(targetView: view)

    for entrypoint in entrypoints {
      switch entrypoint {
      case .block(let block):
        block.setupConstraints(parent: .init(view: view), in: context)
      case .container(let container):
        container.setupConstraints(parent: view, in: context)
      }
    }

    context.prepareViewHierarchy()
    context.activate()

    return context
  }

}
