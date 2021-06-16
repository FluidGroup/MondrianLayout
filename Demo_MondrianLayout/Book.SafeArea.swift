
import StorybookKit
import UIKit

import MondrianLayout

var _book_SafeArea: BookView {
  BookNavigationLink(title: "SafeArea") {

    BookPush(title: "Push") {
      AnyViewController { view in
        view.buildSublayersLayout {
          SafeAreaConstraint(edge: .vertical) {
            ZStackConstraint {

              UIView.mock(
                backgroundColor: .layeringColor,
                preferredSize: .init(width: 100, height: 100)
              )

              ZStackConstraint {
                UIView.mock(backgroundColor: .layeringColor)

                ZStackConstraint {
                  UIView.mock(backgroundColor: .layeringColor)

                  ZStackConstraint {
                    UIView.mock(backgroundColor: .layeringColor)
                  }
                  .relative(top: 10, left: 10, bottom: 10, right: 10)
                }
                .relative(top: 10, left: 10, bottom: 10, right: 10)
              }
              .relative(top: 10, left: 10, bottom: 10, right: 10)

            }
          }
        }
      }
    }

  }
}

fileprivate final class AnyViewController: UIViewController {

  private let onViewDidLoad: (UIView) -> Void

  init(onViewDidLoad: @escaping (UIView) -> Void) {
    self.onViewDidLoad = onViewDidLoad

    super.init(nibName: nil, bundle: nil)

    if #available(iOS 13.0, *) {
      view.backgroundColor = .systemBackground
    } else {
      view.backgroundColor = .white
    }
  }

  required init?(coder: NSCoder) {
    fatalError()
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    onViewDidLoad(view)
  }

}
