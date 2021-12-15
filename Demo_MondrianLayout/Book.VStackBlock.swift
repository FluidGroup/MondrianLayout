import MondrianLayout
import StorybookKit
import UIKit

var _book_VStackBlock: BookView {

  BookNavigationLink(title: "VStackBlock") {

    BookPreview {
      ExampleView(width: 200, height: 200) { (view: UIView) in
        Mondrian.buildSubviews(on: view) {
          VStackBlock(alignment: .leading) {
            UILabel.mockMultiline(text: BookGenerator.loremIpsum(length: 10))
              .viewBlock
              .padding(.horizontal, 10)
            UIView.mock(backgroundColor: .layeringColor)
              .viewBlock
              .alignSelf(.fill)
          }
          .background(UIView.mock(backgroundColor: .layeringColor))
        }
      }
    }
    .title("Spacing")

    BookPreview {
      ExampleView(width: nil, height: 180) { (view: UIView) in
        Mondrian.buildSubviews(on: view) {
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
          Mondrian.buildSubviews(on: view) {
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
        Mondrian.buildSubviews(on: view) {
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
        Mondrian.buildSubviews(on: view) {
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

    BookPreview {
      ExampleView(width: 200, height: 200) { (view: UIView) in

        let boxes = (0..<3).map { _ in UIView.mock(backgroundColor: .layeringColor) }
        let guides = (0..<2).map { _ in UILayoutGuide() }

        Mondrian.buildSubviews(on: view) {
          VStackBlock(alignment: .leading) {

            boxes[0]

            guides[0]

            boxes[1]

            guides[1]

            boxes[2]

            StackingSpacer(minLength: 0)

          }
          .background(UIView.mock(backgroundColor: .layeringColor))
        }

        mondrianBatchLayout {

          boxes.map { $0.mondrian.layout.height(20) }

          guides[0].mondrian.layout.height(.to(boxes[0]))
          guides[1].mondrian.layout.height(.to(boxes[2]), multiplier: 2)
        }
      }
    }
    .title("Including LayoutGuide")

  }
}
