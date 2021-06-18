
import StorybookKit
import UIKit

import MondrianLayout

var _book_ZStackConstraint: BookView {
  BookNavigationLink(title: "ZStackBlock") {

    BookPreview {
      ExampleView(width: 100, height: 100) { view in
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

    BookPreview {
      ExampleView(width: nil, height: nil) { (view: UIView) in
        view.buildSublayersLayout {
          VStackBlock {
            ZStackBlock {
              UIView.mock(
                backgroundColor: .mondrianYellow,
                preferredSize: .init(width: 100, height: 100)
              )

              UIView.mock(
                backgroundColor: .systemBlue,
                preferredSize: .init(width: 10, height: 10)
              )
              .viewBlock
              .relative(top: 10, right: 10)

            }
          }
        }
      }
    }

    BookPreview {
      ExampleView(width: nil, height: nil) { (view: UIView) in
        view.buildSublayersLayout {
          VStackBlock {
            UIView.mock(
              backgroundColor: .mondrianYellow,
              preferredSize: .init(width: 30, height: 30)
            )
            ZStackBlock {
              UIView.mock(
                backgroundColor: .mondrianYellow,
                preferredSize: .init(width: 100, height: 100)
              )

              UIView.mock(
                backgroundColor: .systemBlue,
                preferredSize: .init(width: 10, height: 10)
              )
              .viewBlock
              .relative(top: 10, right: 10)

            }
            ZStackBlock {
              UIView.mock(
                backgroundColor: .mondrianYellow,
                preferredSize: .init(width: 100, height: 100)
              )

              UIView.mock(
                backgroundColor: .systemBlue,
                preferredSize: .init(width: 10, height: 10)
              )
              .viewBlock
              .relative(top: 10, right: 10)

            }
          }
        }
      }
    }

    BookPreview {
      ExampleView(width: nil, height: nil) { (view: UIView) in
        view.buildSublayersLayout {
          VStackBlock {
            UIView.mock(
              backgroundColor: .mondrianYellow,
              preferredSize: .init(width: 30, height: 30)
            )
            UIView.mock(
              backgroundColor: .mondrianYellow,
              preferredSize: .init(width: 30, height: 30)
            )
            UIView.mock(
              backgroundColor: .mondrianYellow,
              preferredSize: .init(width: 30, height: 30)
            )
          }
        }
      }
    }

    BookPreview {
      ExampleView(width: nil, height: nil) { (view: UIView) in
        view.buildSublayersLayout {
          ZStackBlock {

            UIView.mock(
              backgroundColor: .layeringColor,
              preferredSize: .init(width: 100, height: 100)
            )

            ZStackBlock {
              UIView.mock(backgroundColor: .layeringColor)

              ZStackBlock {
                UIView.mock(backgroundColor: .layeringColor)

                ZStackBlock {
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
