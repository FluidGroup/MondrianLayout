import MondrianLayout
import StorybookKit
import UIKit

var _book_SafeArea: BookView {
  BookNavigationLink(title: "SafeArea") {

    BookPush(title: "Push") {
      AnyViewController { view in
        view.buildSublayersLayout(safeArea: .vertical) {
          VStackBlock {
            UIView.mock(
              backgroundColor: .layeringColor,
              preferredSize: .init(width: 100, height: 100)
            )
            UIView.mock(
              backgroundColor: .layeringColor,
              preferredSize: .init(width: 100, height: 100)
            )
            UIView.mock(
              backgroundColor: .layeringColor,
              preferredSize: .init(width: 100, height: 100)
            )
          }
        }
      }
    }

    BookPush(title: "Push") {
      AnyViewController { view in
        view.buildSublayersLayout(safeArea: .vertical) {
          ZStackBlock {
            UIView.mock(
              backgroundColor: .layeringColor
            )

            UIView.mock(
              backgroundColor: .mondrianBlue,
              preferredSize: .smallSquare
            )
          }
        }
      }
    }

  }
}

private final class AnyViewController: UIViewController {

  private let onViewDidLoad: (UIView) -> Void

  init(
    onViewDidLoad: @escaping (UIView) -> Void
  ) {
    self.onViewDidLoad = onViewDidLoad

    super.init(nibName: nil, bundle: nil)

    if #available(iOS 13.0, *) {
      view.backgroundColor = .systemBackground
    } else {
      view.backgroundColor = .white
    }
  }

  required init?(
    coder: NSCoder
  ) {
    fatalError()
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    onViewDidLoad(view)
  }

}
