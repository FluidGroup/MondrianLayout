import MondrianLayout
import StorybookKit
import UIKit

var _book_ZStackConstraint: BookView {
  BookNavigationLink(title: "ZStackBlock") {

    BookPreview {
      ExampleView(width: 100, height: 100) { view in
        Mondrian.buildSubviews(on: view) {
          ZStackBlock {
            ZStackBlock {
              UILabel.mockSingleline(text: "Hello Hello Hello")
                .viewBlock
                .background(UIView.mock())
            }
            .padding(20)
          }
          .background(UIView.mock())
        }
      }
    }
    .title("Centering a label with minimum padding in the container")

    BookPreview {
      ExampleView(width: 100, height: 100) { view in
        Mondrian.buildSubviews(on: view) {
          LayoutContainer(attachedSafeAreaEdges: .vertical) {
            ZStackBlock {

              UIView.mock(
                backgroundColor: .layeringColor,
                preferredSize: .smallSquare
              )
              .viewBlock
              .alignSelf(.attach(.all))

              UIView.mock(
                backgroundColor: .layeringColor,
                preferredSize: .smallSquare
              )
              .viewBlock
              .alignSelf(.attach(.top))

              UIView.mock(
                backgroundColor: .layeringColor,
                preferredSize: .smallSquare
              )
              .viewBlock
              .alignSelf(.attach(.bottom))

              UIView.mock(
                backgroundColor: .layeringColor,
                preferredSize: .smallSquare
              )
              .viewBlock
              .alignSelf(.attach(.leading))

              UIView.mock(
                backgroundColor: .layeringColor,
                preferredSize: .smallSquare
              )
              .viewBlock
              .alignSelf(.attach(.trailing))

              UIView.mock(
                backgroundColor: .layeringColor,
                preferredSize: .smallSquare
              )
              .viewBlock
              .alignSelf(.attach([.top, .leading]))

              UIView.mock(
                backgroundColor: .layeringColor,
                preferredSize: .smallSquare
              )
              .viewBlock
              .alignSelf(.attach([.top, .trailing]))

              UIView.mock(
                backgroundColor: .layeringColor,
                preferredSize: .smallSquare
              )
              .viewBlock
              .alignSelf(.attach([.bottom, .leading]))

              UIView.mock(
                backgroundColor: .layeringColor,
                preferredSize: .smallSquare
              )
              .viewBlock
              .alignSelf(.attach([.bottom, .trailing]))

              UIView.mock(
                backgroundColor: .layeringColor,
                preferredSize: .smallSquare
              )
              .viewBlock
              .alignSelf(.attach([.top, .bottom]))

              UIView.mock(
                backgroundColor: .layeringColor,
                preferredSize: .smallSquare
              )
              .viewBlock
              .alignSelf(.attach([.leading, .trailing]))

              UIView.mock(
                backgroundColor: .layeringColor,
                preferredSize: .smallSquare
              )
              .viewBlock
              .alignSelf(.attach([.top, .leading, .trailing]))

              UIView.mock(
                backgroundColor: .layeringColor,
                preferredSize: .smallSquare
              )
              .viewBlock
              .alignSelf(.attach([.bottom, .leading, .trailing]))

              UIView.mock(
                backgroundColor: .layeringColor,
                preferredSize: .smallSquare
              )
              .viewBlock
              .alignSelf(.attach([.top, .bottom, .leading]))

              UIView.mock(
                backgroundColor: .layeringColor,
                preferredSize: .smallSquare
              )
              .viewBlock
              .alignSelf(.attach([.top, .bottom, .trailing]))

              UIView.mock(
                backgroundColor: .layeringColor,
                preferredSize: .smallSquare
              )
              .viewBlock
              .alignSelf(.attach([]))

              UIView.mock(
                backgroundColor: .layeringColor,
                preferredSize: .smallSquare
              )
              .viewBlock
              .alignSelf(.center)

            }
          }
        }
      }
    }

    BookParagraph(
      "ZStackBlock expands view to fill that if don't have exact intrinsic content size"
    )
    BookPreview {
      ExampleView(width: 100, height: 100) { view in
        Mondrian.buildSubviews(on: view) {
          LayoutContainer(attachedSafeAreaEdges: .vertical) {
            ZStackBlock {
              UIView.mock(
                backgroundColor: .layeringColor
              )

              UIView.mock(
                backgroundColor: .mondrianBlue,
                preferredSize: .smallSquare
              )
            }
          }
        }
      }
    }

    BookParagraph("The view has intrinsicContentSize but expanded by relative modifier")
    BookPreview {
      ExampleView(width: 100, height: 100) { view in
        Mondrian.buildSubviews(on: view) {
          LayoutContainer(attachedSafeAreaEdges: .vertical) {
            ZStackBlock {
              UIView.mock(
                backgroundColor: .mondrianBlue,
                preferredSize: .smallSquare
              )
              .viewBlock
              .relative(0)
            }
          }
        }
      }
    }

    BookPreview {
      ExampleView(width: nil, height: nil) { (view: UIView) in
        Mondrian.buildSubviews(on: view) {
          VStackBlock {
            ZStackBlock {
              UIView.mock(
                backgroundColor: .mondrianYellow,
                preferredSize: .init(width: 100, height: 100)
              )

              UIView.mock(
                backgroundColor: .systemBlue,
                preferredSize: .init(width: 10, height: 10)
              )
              .viewBlock
              .relative([.top, .trailing], 10)

            }
          }
        }
      }
    }

    BookPreview {
      ExampleView(width: nil, height: nil) { (view: UIView) in
        Mondrian.buildSubviews(on: view) {
          VStackBlock {
            UIView.mock(
              backgroundColor: .mondrianYellow,
              preferredSize: .init(width: 30, height: 30)
            )
            ZStackBlock {
              UIView.mock(
                backgroundColor: .mondrianYellow,
                preferredSize: .init(width: 100, height: 100)
              )

              UIView.mock(
                backgroundColor: .systemBlue,
                preferredSize: .init(width: 10, height: 10)
              )
              .viewBlock
              .relative([.top, .trailing], 10)

            }
            ZStackBlock {
              UIView.mock(
                backgroundColor: .mondrianYellow,
                preferredSize: .init(width: 100, height: 100)
              )

              UIView.mock(
                backgroundColor: .systemBlue,
                preferredSize: .init(width: 10, height: 10)
              )
              .viewBlock
              .relative([.top, .trailing], 10)

            }
          }
        }
      }
    }

    BookPreview {
      ExampleView(width: nil, height: nil) { (view: UIView) in
        Mondrian.buildSubviews(on: view) {
          VStackBlock {
            UIView.mock(
              backgroundColor: .mondrianYellow,
              preferredSize: .init(width: 30, height: 30)
            )
            UIView.mock(
              backgroundColor: .mondrianYellow,
              preferredSize: .init(width: 30, height: 30)
            )
            UIView.mock(
              backgroundColor: .mondrianYellow,
              preferredSize: .init(width: 30, height: 30)
            )
          }
        }
      }
    }

    BookPreview {
      ExampleView(width: nil, height: nil) { (view: UIView) in
        Mondrian.buildSubviews(on: view) {
          ZStackBlock {

            UIView.mock(
              backgroundColor: .layeringColor,
              preferredSize: .init(width: 100, height: 100)
            )

            ZStackBlock {
              UIView.mock(backgroundColor: .layeringColor)

              ZStackBlock {
                UIView.mock(backgroundColor: .layeringColor)

                ZStackBlock {
                  UIView.mock(backgroundColor: .layeringColor)
                }
                .relative(10)
              }
              .relative(10)
            }
            .relative(10)
          }
        }
      }
    }

  }
}
