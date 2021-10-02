import UIKit

open class AnyView: UIView {

  public init(build: (AnyView) -> LayoutContainer) {
    super.init(frame: .zero)
    mondrian.buildSubviews {
      build(self)
    }
  }

  public init<Block: _LayoutBlockType>(build: (AnyView) -> Block) {
    super.init(frame: .zero)
    mondrian.buildSubviews {
      build(self)
    }
  }

  @available(*, unavailable)
  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
