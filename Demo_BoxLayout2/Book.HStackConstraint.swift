
import StorybookKit
import UIKit

import BoxLayout2

var _book_HStackConstraint: BookView {
  BookNavigationLink(title: "HStackConstraint") {

    BookForEach(data: [.center, .top, .bottom] as [HStackConstraint.VerticalAlignment]) { alignment in
      BookPreview {
        ExampleView(width: nil, height: nil) { (view: UIView) in
          view.buildSublayersLayout {
            HStackConstraint(spacing: 4, alignment: alignment) {
              UILabel.mockMultiline(text: "Hello\nHello", textColor: .white)
                .viewConstraint
                .padding(8)
                .background(UIView.mock(backgroundColor: .mondrianYellow))
              UILabel.mockMultiline(text: "Mondrian Mondrian Mondrian", textColor: .white)
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

    BookPreview {
      ExampleView(width: nil, height: nil) { (view: UIView) in
        view.buildSublayersLayout {
          HStackConstraint(spacing: 4) {
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
          HStackConstraint(spacing: 4) {
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


  }
}
