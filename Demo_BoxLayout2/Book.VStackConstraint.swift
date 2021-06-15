import BoxLayout2
import StorybookKit
import UIKit

var _book_VStackConstraint: BookView {

  BookNavigationLink(title: "VStackConstraint") {

    BookPreview {
      ExampleView(width: nil, height: nil) { (view: UIView) in
        view.buildSublayersLayout {
          VStackConstraint(spacing: 4) {
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
          VStackConstraint(spacing: 4) {
            UIView.mock(
              backgroundColor: .mondrianYellow,
              preferredSize: .init(width: 28, height: 28)
            )

            SpaceConstraint(minLength: 4)

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

    BookForEach(data: [.center, .leading, .trailing] as [VStackConstraint.HorizontalAlignment]) { alignment in
      BookPreview {
        ExampleView(width: nil, height: nil) { (view: UIView) in
          view.buildSublayersLayout {
            VStackConstraint(spacing: 4, alignment: alignment) {
              UILabel.mockMultiline(text: "Hello", textColor: .white)
                .viewConstraint
                .padding(8)
                .background(UIView.mock(backgroundColor: .mondrianYellow))
              UILabel.mockMultiline(text: "Mondrian", textColor: .white)
                .viewConstraint
                .padding(8)
                .background(UIView.mock(backgroundColor: .mondrianRed))
              UILabel.mockMultiline(text: "Layout!", textColor: .white)
                .viewConstraint
                .padding(8)
                .background(UIView.mock(backgroundColor: .mondrianBlue))
            }
          }
        }
      }
      .title("Labels - align: \(alignment)")
    }

  }
}
