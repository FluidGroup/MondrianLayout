import MondrianLayout
import StorybookKit
import UIKit

var _book_overlay: BookView {
  BookNavigationLink(title: "Overlay") {

    BookPreview {
      ExampleView(width: nil, height: nil) { (view: UIView) in

        Mondrian.buildSubviews(on: view) {
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
        Mondrian.buildSubviews(on: view) {
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
        Mondrian.buildSubviews(on: view) {
          VStackBlock {
            UIView.mock(
              backgroundColor: .mondrianYellow,
              preferredSize: .smallSquare
            )
            UIView.mock(
              backgroundColor: .mondrianYellow,
              preferredSize: .smallSquare
            )
            UIView.mock(
              backgroundColor: .mondrianYellow,
              preferredSize: .smallSquare
            )
          }
          .padding(10)
          .overlay(UIView.mock(backgroundColor: .layeringColor))
        }
      }
    }

    BookPreview {
      ExampleView(width: nil, height: nil) { (view: UIView) in
        Mondrian.buildSubviews(on: view) {
          VStackBlock(spacing: 2) {
            UIView.mock(
              backgroundColor: .mondrianYellow,
              preferredSize: .smallSquare
            )
            UIView.mock(
              backgroundColor: .mondrianYellow,
              preferredSize: .smallSquare
            )
            UIView.mock(
              backgroundColor: .mondrianYellow,
              preferredSize: .smallSquare
            )

            HStackBlock(spacing: 2) {
              UIView.mock(
                backgroundColor: .mondrianBlue,
                preferredSize: .smallSquare
              )
              UIView.mock(
                backgroundColor: .mondrianBlue,
                preferredSize: .smallSquare
              )
              UIView.mock(
                backgroundColor: .mondrianBlue,
                preferredSize: .smallSquare
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
        Mondrian.buildSubviews(on: view) {
          VStackBlock {
            UIView.mock(
              backgroundColor: .mondrianYellow,
              preferredSize: .smallSquare
            )
            UIView.mock(
              backgroundColor: .mondrianYellow,
              preferredSize: .smallSquare
            )
            UIView.mock(
              backgroundColor: .mondrianYellow,
              preferredSize: .smallSquare
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
