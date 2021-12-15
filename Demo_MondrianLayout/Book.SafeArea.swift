import MondrianLayout
import StorybookKit
import UIKit

var _book_SafeArea: BookView {
  BookNavigationLink(title: "SafeArea") {

    BookPush(title: "Push") {
      AnyViewController { view in
        Mondrian.buildSubviews(on: view) {
          LayoutContainer(attachedSafeAreaEdges: .vertical) {
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
    }

    BookPush(title: "Push custom") {
      AnyViewController { view in

        Mondrian.buildSubviews(on: view) {
          LayoutContainer(top: .view(.top), leading: .view(.leading), bottom: .safeArea(.top), trailing: .view(.trailing)) {
            UIView.mock(
              backgroundColor: .layeringColor,
              preferredSize: .init(width: 100, height: 100)
            )
            .viewBlock
          }

        }

        Mondrian.buildSubviews(on: view) {
          LayoutContainer(attachedSafeAreaEdges: .vertical) {
            UIView.mock(
              backgroundColor: .layeringColor,
              preferredSize: .init(width: 100, height: 100)
            )
            .viewBlock
          }

        }
      }
    }

    BookPush(title: "Push") {
      AnyViewController { view in
        Mondrian.buildSubviews(on: view) {
          LayoutContainer(attachedSafeAreaEdges: .vertical) {
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

    BookPush(title: "Bottom Buttons") {
      AnyViewController { view in
        Mondrian.buildSubviews(on: view) {
          LayoutContainer(attachedSafeAreaEdges: .vertical) {
            ZStackBlock {

              VStackBlock(alignment: .center) {
                HStackBlock {
                  UIView.mock(
                    backgroundColor: .mondrianBlue,
                    preferredSize: .init(width: 20, height: 30)
                  )
                  UIView.mock(
                    backgroundColor: .mondrianBlue,
                    preferredSize: .init(width: 20, height: 10)
                  )
                  UIView.mock(
                    backgroundColor: .mondrianBlue,
                    preferredSize: .init(width: 20, height: 20)
                  )
                }
              }
              .padding(20)
              .background(
                UIView.mock(
                  backgroundColor: .layeringColor
                )
              )
              .relative([.horizontal, .bottom], 0)

            }
          }
        }
      }
    }

  }
}

final class AnyViewController: UIViewController {

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

    additionalSafeAreaInsets = .init(top: 60, left: 60, bottom: 60, right: 60)
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
