import MondrianLayout
import StorybookKit
import UIKit

var _book_VStackBlock: BookView {

  BookNavigationLink(title: "VStackBlock") {
    BookPreview {
      ExampleView(width: nil, height: 180) { (view: UIView) in
        view.mondrian.buildSubviews {
          VStackBlock(spacing: 4) {
            UIView.mock(
              backgroundColor: .mondrianYellow,
              preferredSize: .smallSquare
            )

            StackingSpacer(minLength: 20)

            UIView.mock(
              backgroundColor: .mondrianYellow,
              preferredSize: .smallSquare
            )

            UIView.mock(
              backgroundColor: .mondrianYellow,
              preferredSize: .smallSquare
            )

            StackingSpacer(minLength: 20, expands: false)
          }
          .background(UIView.mock(backgroundColor: .layeringColor))
        }
      }
    }
    .title("Spacing")

    BookForEach(data: [.center, .leading, .trailing, .fill] as [VStackBlock.XAxisAlignment]) { alignment in
      BookPreview {
        ExampleView(width: nil, height: nil) { (view: UIView) in
          view.mondrian.buildSubviews {
            VStackBlock(spacing: 4, alignment: alignment) {
              UILabel.mockMultiline(text: "Hello", textColor: .white)
                .viewBlock
                .padding(8)
                .background(UIView.mock(backgroundColor: .mondrianYellow))
              UILabel.mockMultiline(text: "Mondrian", textColor: .white)
                .viewBlock
                .padding(8)
                .background(UIView.mock(backgroundColor: .mondrianRed))
              UILabel.mockMultiline(text: "Layout!", textColor: .white)
                .viewBlock
                .padding(8)
                .background(UIView.mock(backgroundColor: .mondrianBlue))
            }
          }
        }
      }
      .title("Labels - align: \(alignment)")
    }

    BookPreview {
      ExampleView(width: nil, height: nil) { (view: UIView) in
        view.mondrian.buildSubviews {
          VStackBlock(spacing: 4) {
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
        }
      }
    }
    .title("Spacing")

    BookPreview {
      ExampleView(width: nil, height: nil) { (view: UIView) in
        view.mondrian.buildSubviews {
          VStackBlock(spacing: 4) {
            UIView.mock(
              backgroundColor: .mondrianYellow,
              preferredSize: .smallSquare
            )

            StackingSpacer(minLength: 4)

            UIView.mock(
              backgroundColor: .mondrianYellow,
              preferredSize: .smallSquare
            )

            UIView.mock(
              backgroundColor: .mondrianYellow,
              preferredSize: .smallSquare
            )
          }
        }
      }
    }
    .title("Spacing with additional spacer")

  }
}
