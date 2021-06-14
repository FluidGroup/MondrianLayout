
import UIKit
import BoxLayout2

final class AnyView: UIView {

  init(
    size: CGSize,
    build: (UIView) -> Void
  ) {
    super.init(frame: .zero)
    build(self)

    setContentHuggingPriority(.required, for: .horizontal)
    setContentHuggingPriority(.required, for: .vertical)

    translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      heightAnchor.constraint(equalToConstant: size.height),
      widthAnchor.constraint(equalToConstant: size.width)
    ])

    layoutIfNeeded()

  }

  required init?(
    coder: NSCoder
  ) {
    fatalError("init(coder:) has not been implemented")
  }

}
