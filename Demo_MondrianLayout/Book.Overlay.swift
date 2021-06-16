import MondrianLayout
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
          .viewBlock
          .overlay(
            UIView.mock(backgroundColor: .layeringColor)
              .viewBlock
              .overlay(
                UIView.mock(backgroundColor: .layeringColor)
                  .viewBlock
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
          VStackBlock {
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
          VStackBlock(spacing: 2) {
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

            HStackBlock(spacing: 2) {
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
          VStackBlock {
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
            .viewBlock
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
