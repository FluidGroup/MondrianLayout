
import StorybookKit
import UIKit

import BoxLayout2

var _book_ZStackConstraint: BookView {
  BookNavigationLink(title: "ZStackConstraint") {
    BookPreview {
      ExampleView(width: nil, height: nil) { (view: UIView) in
        view.buildSublayersLayout {
          VStackConstraint {
            ZStackConstraint {
              UIView.mock(
                backgroundColor: .mondrianYellow,
                preferredSize: .init(width: 100, height: 100)
              )

              UIView.mock(
                backgroundColor: .systemBlue,
                preferredSize: .init(width: 10, height: 10)
              )
              .viewConstraint
              .relative(top: 10, right: 10)

            }
          }
        }
      }
    }

    BookPreview {
      ExampleView(width: nil, height: nil) { (view: UIView) in
        view.buildSublayersLayout {
          VStackConstraint {
            UIView.mock(
              backgroundColor: .mondrianYellow,
              preferredSize: .init(width: 30, height: 30)
            )
            ZStackConstraint {
              UIView.mock(
                backgroundColor: .mondrianYellow,
                preferredSize: .init(width: 100, height: 100)
              )

              UIView.mock(
                backgroundColor: .systemBlue,
                preferredSize: .init(width: 10, height: 10)
              )
              .viewConstraint
              .relative(top: 10, right: 10)

            }
            ZStackConstraint {
              UIView.mock(
                backgroundColor: .mondrianYellow,
                preferredSize: .init(width: 100, height: 100)
              )

              UIView.mock(
                backgroundColor: .systemBlue,
                preferredSize: .init(width: 10, height: 10)
              )
              .viewConstraint
              .relative(top: 10, right: 10)

            }
          }
        }
      }
    }

    BookPreview {
      ExampleView(width: nil, height: nil) { (view: UIView) in
        view.buildSublayersLayout {
          VStackConstraint {
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
