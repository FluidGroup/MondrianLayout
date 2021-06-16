import MondrianLayout
import StorybookKit
import UIKit

var _book_VStackBlock: BookView {

  BookNavigationLink(title: "VStackBlock") {

    BookForEach(data: [.center, .leading, .trailing, .fill] as [VStackBlock.HorizontalAlignment]) { alignment in
      BookPreview {
        ExampleView(width: nil, height: nil) { (view: UIView) in
          view.buildSublayersLayout {
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
        view.buildSublayersLayout {
          VStackBlock(spacing: 4) {
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
        }
      }
    }
    .title("Spacing")

    BookPreview {
      ExampleView(width: nil, height: nil) { (view: UIView) in
        view.buildSublayersLayout {
          VStackBlock(spacing: 4) {
            UIView.mock(
              backgroundColor: .mondrianYellow,
              preferredSize: .init(width: 28, height: 28)
            )

            SpacerBlock(minLength: 4)

            UIView.mock(
              backgroundColor: .mondrianYellow,
              preferredSize: .init(width: 28, height: 28)
            )

            UIView.mock(
              backgroundColor: .mondrianYellow,
              preferredSize: .init(width: 28, height: 28)
            )
          }
        }
      }
    }
    .title("Spacing with additional spacer")

  }
}
