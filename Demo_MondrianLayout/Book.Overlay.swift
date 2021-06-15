import BoxLayout2
import StorybookKit
import UIKit

var _book_overlay: BookView {
  BookNavigationLink(title: "Overlay") {

    BookPreview {
      ExampleView(width: nil, height: nil) { (view: UIView) in
        view.buildSublayersLayout {
          UIView.mock(
            backgroundColor: .mondrianYellow,
            preferredSize: .init(width: 100, height: 100)
          )
          .viewConstraint
          .overlay(
            UIView.mock(backgroundColor: .layeringColor)
              .viewConstraint
              .overlay(
                UIView.mock(backgroundColor: .layeringColor)
                  .viewConstraint
                  .padding(10)
              )
              .padding(10)
          )
        }
      }
    }

    BookPreview {
      ExampleView(width: nil, height: nil) { (view: UIView) in
        view.buildSublayersLayout {
          VStackConstraint {
            UIView.mock(
              backgroundColor: .mondrianYellow,
              preferredSize: .init(width: 28, height: 28)
            )
            UIView.mock(
              backgroundColor: .mondrianYellow,
              preferredSize: .init(width: 28, height: 28)
            )
            UIView.mock(
              backgroundColor: .mondrianYellow,
              preferredSize: .init(width: 28, height: 28)
            )
          }
          .padding(10)
          .overlay(UIView.mock(backgroundColor: .layeringColor))
        }
      }
    }

    BookPreview {
      ExampleView(width: nil, height: nil) { (view: UIView) in
        view.buildSublayersLayout {
          VStackConstraint(spacing: 2) {
            UIView.mock(
              backgroundColor: .mondrianYellow,
              preferredSize: .init(width: 28, height: 28)
            )
            UIView.mock(
              backgroundColor: .mondrianYellow,
              preferredSize: .init(width: 28, height: 28)
            )
            UIView.mock(
              backgroundColor: .mondrianYellow,
              preferredSize: .init(width: 28, height: 28)
            )

            HStackConstraint(spacing: 2) {
              UIView.mock(
                backgroundColor: .mondrianBlue,
                preferredSize: .init(width: 28, height: 28)
              )
              UIView.mock(
                backgroundColor: .mondrianBlue,
                preferredSize: .init(width: 28, height: 28)
              )
              UIView.mock(
                backgroundColor: .mondrianBlue,
                preferredSize: .init(width: 28, height: 28)
              )
            }

          }
          .padding(10)
          .overlay(UIView.mock(backgroundColor: .layeringColor))
        }
      }
    }

    BookPreview {
      ExampleView(width: nil, height: nil) { (view: UIView) in
        view.buildSublayersLayout {
          VStackConstraint {
            UIView.mock(
              backgroundColor: .mondrianYellow,
              preferredSize: .init(width: 28, height: 28)
            )
            UIView.mock(
              backgroundColor: .mondrianYellow,
              preferredSize: .init(width: 28, height: 28)
            )
            UIView.mock(
              backgroundColor: .mondrianYellow,
              preferredSize: .init(width: 28, height: 28)
            )
            .viewConstraint
            .padding(10)
            .overlay(UIView.mock(backgroundColor: .layeringColor))
          }
          .padding(10)
          .overlay(UIView.mock(backgroundColor: .layeringColor))
        }
      }
    }
  }
}
