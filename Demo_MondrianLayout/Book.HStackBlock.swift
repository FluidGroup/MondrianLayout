import MondrianLayout
import StorybookKit
import UIKit

var _book_HStackBlock: BookView {
  BookNavigationLink(title: "HStackBlock") {

    BookSection(title: "Justify (Distribution)") {

      BookParagraph("Wrapping with VStack")

      BookForEach(data: [VStackBlock.XAxisAlignment]([.leading, .center, .trailing])) {
        alignment in
        BookPreview {
          ExampleView(width: 180, height: nil) { (view: UIView) in
            Mondrian.buildSubviews(on: view) {
              VStackBlock(alignment: alignment) {

                HStackBlock(spacing: 4) {

                  UIView.mock(
                    backgroundColor: .mondrianYellow,
                    preferredSize: .smallSquare
                  )

                  UIView.mock(
                    backgroundColor: .mondrianRed,
                    preferredSize: .smallSquare
                  )

                  UIView.mock(
                    backgroundColor: .mondrianBlue,
                    preferredSize: .smallSquare
                  )

                }
                .background(UIView.mock(backgroundColor: .layeringColor))

              }
              .background(UIView.mock(backgroundColor: .layeringColor))
            }
          }
        }
        .title("\(alignment)")
      }
    }

    BookSection(title: "1 element") {
      BookForEach(data: [VStackBlock.XAxisAlignment]([.leading, .center, .trailing])) {
        alignment in
        BookPreview {
          ExampleView(width: 60, height: nil) { (view: UIView) in
            Mondrian.buildSubviews(on: view) {
              VStackBlock(alignment: alignment) {

                UIView.mock(
                  backgroundColor: .mondrianYellow,
                  preferredSize: .smallSquare
                )

              }
              .background(UIView.mock(backgroundColor: .layeringColor))
            }
          }
        }
      }

      BookForEach(data: [VStackBlock.XAxisAlignment]([.leading, .center, .trailing])) {
        alignment in
        BookPreview {
          ExampleView(width: 60, height: nil) { (view: UIView) in
            Mondrian.buildSubviews(on: view) {
              VStackBlock(alignment: alignment) {

                StackingSpacer(minLength: 10)

              }
              .background(UIView.mock(backgroundColor: .layeringColor))
            }
          }
        }
      }

    }

    BookSection(title: "Examples") {

      BookPreview {
        ExampleView(width: 180, height: nil) { (view: UIView) in
          Mondrian.buildSubviews(on: view) {
            VStackBlock {
              HStackBlock(spacing: 10) {
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

              HStackBlock(spacing: 10) {
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

                StackingSpacer(minLength: 20, expands: false)
              }
              .background(UIView.mock(backgroundColor: .layeringColor))

              HStackBlock(spacing: 0) {
                UIView.mock(
                  backgroundColor: .mondrianYellow,
                  preferredSize: .smallSquare
                )
                .viewBlock
                .spacingAfter(10)

                UIView.mock(
                  backgroundColor: .mondrianYellow,
                  preferredSize: .smallSquare
                )

                UIView.mock(
                  backgroundColor: .mondrianYellow,
                  preferredSize: .smallSquare
                )

              }
              .background(UIView.mock(backgroundColor: .layeringColor))

              HStackBlock(spacing: 0) {
                UIView.mock(
                  backgroundColor: .mondrianYellow,
                  preferredSize: .smallSquare
                )

                StackingSpacer(minLength: 20, expands: false)
                StackingSpacer(minLength: 20, expands: false)
                StackingSpacer(minLength: 20, expands: false)

                UIView.mock(
                  backgroundColor: .mondrianYellow,
                  preferredSize: .smallSquare
                )

              }
              .background(UIView.mock(backgroundColor: .layeringColor))
            }
          }
        }
      }
      .title("Spacing and additional space")

      BookForEach(data: [.center, .top, .bottom, .fill] as [HStackBlock.YAxisAlignment]) {
        alignment in
        BookPreview {
          ExampleView(width: nil, height: nil) { (view: UIView) in
            Mondrian.buildSubviews(on: view) {
              HStackBlock(spacing: 4, alignment: alignment) {
                UILabel.mockMultiline(text: "Hello\nHello", textColor: .white)
                  .viewBlock
                  .padding(8)
                  .background(UIView.mock(backgroundColor: .mondrianYellow))
                UILabel.mockMultiline(text: "Mondrian Mondrian Mondrian", textColor: .white)
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
            HStackBlock(spacing: 4) {
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
            HStackBlock(spacing: 4) {
              UIView.mock(
                backgroundColor: .mondrianYellow,
                preferredSize: .smallSquare
              )
              .viewBlock
              .alignSelf(.fill)

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
}
