import MondrianLayout
import StorybookKit
import UIKit

var _book_VGridConstraint: BookView {

  BookNavigationLink(title: "VGridBlock") {

    BookPreview {
      ExampleView(width: 100, height: nil) { view in
        Mondrian.buildSubviews(on: view) {
          VGridBlock(
            columns: [
              .init(.flexible(), spacing: 16),
              .init(.flexible(), spacing: 16),
            ],
            spacing: 4
          ) {

            UILabel.mockMultiline(text: "Helloooo")
              .viewBlock
              .overlay(UIView.mock(backgroundColor: .layeringColor, preferredSize: .smallSquare))

            UIView.mock(backgroundColor: .neon(.cyan), preferredSize: .smallSquare)
            UIView.mock(backgroundColor: .neon(.cyan), preferredSize: .smallSquare)
            UIView.mock(backgroundColor: .neon(.cyan), preferredSize: .smallSquare)

            UIView.mock(backgroundColor: .neon(.cyan), preferredSize: .smallSquare)
            UIView.mock(backgroundColor: .neon(.cyan), preferredSize: .smallSquare)
            UIView.mock(backgroundColor: .neon(.cyan), preferredSize: .smallSquare)
            UIView.mock(backgroundColor: .neon(.cyan), preferredSize: .smallSquare)

            UIView.mock(backgroundColor: .neon(.cyan), preferredSize: .smallSquare)
            UIView.mock(backgroundColor: .neon(.cyan), preferredSize: .smallSquare)
          }
        }
      }
    }
    .title("Grid")

  }

}
