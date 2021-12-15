import StorybookKit
import UIKit

import MondrianLayout

var _book_background: BookView {
  BookNavigationLink(title: "Background") {
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
          .background(UIView.mock(backgroundColor: .mondrianGray))
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
          .background(UIView.mock(backgroundColor: .mondrianGray))
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
            .background(UIView.mock(backgroundColor: .mondrianGray))
          }
          .padding(10)
          .background(UIView.mock(backgroundColor: .mondrianGray))
        }
      }
    }
  }
}
