import MondrianLayout
import Ne
import StorybookKit
import UIKit

var _book_mondrian: BookView {
  BookPreview {
    ExampleView(width: 200, height: 200) { (view: UIView) in
      Mondrian.buildSubviews(on: view) {

        HStackBlock(spacing: 2, alignment: .fill) {
          VStackBlock(spacing: 2, alignment: .fill) {
            UIView.mock(
              backgroundColor: .mondrianRed,
              preferredSize: .smallSquare
            )

            UIView.mock(
              backgroundColor: .layeringColor,
              preferredSize: .init(width: 28, height: 50)
            )

            UIView.mock(
              backgroundColor: .mondrianYellow,
              preferredSize: .smallSquare
            )

            UIView.mock(
              backgroundColor: .layeringColor,
              preferredSize: .smallSquare
            )

            HStackBlock(spacing: 2, alignment: .fill) {
              UIView.mock(
                backgroundColor: .layeringColor,
                preferredSize: .smallSquare
              )
              UIView.mock(
                backgroundColor: .layeringColor,
                preferredSize: .smallSquare
              )
            }
          }

          VStackBlock(spacing: 2, alignment: .fill) {
            HStackBlock(spacing: 2, alignment: .fill) {
              UIView.mock(
                backgroundColor: .layeringColor,
                preferredSize: .smallSquare
              )
              VStackBlock(spacing: 2, alignment: .fill) {
                HStackBlock(spacing: 2, alignment: .fill) {
                  UIView.mock(
                    backgroundColor: .mondrianYellow,
                    preferredSize: .smallSquare
                  )
                  UIView.mock(
                    backgroundColor: .layeringColor,
                    preferredSize: .smallSquare
                  )
                }
                UIView.mock(
                  backgroundColor: .layeringColor,
                  preferredSize: .smallSquare
                )
              }
            }

            HStackBlock(spacing: 2, alignment: .fill) {
              VStackBlock(spacing: 2, alignment: .fill) {
                UIView.mock(
                  backgroundColor: .layeringColor,
                  preferredSize: .smallSquare
                )
                UIView.mock(
                  backgroundColor: .mondrianBlue,
                  preferredSize: .smallSquare
                )
              }

              UIView.mock(
                backgroundColor: .layeringColor,
                preferredSize: .smallSquare
              )

              VStackBlock(spacing: 2, alignment: .fill) {
                UIView.mock(
                  backgroundColor: .layeringColor,
                  preferredSize: .smallSquare
                )
                UIView.mock(
                  backgroundColor: .layeringColor,
                  preferredSize: .smallSquare
                )
              }
            }

            HStackBlock(spacing: 2, alignment: .fill) {
              UIView.mock(
                backgroundColor: .mondrianRed,
                preferredSize: .smallSquare
              )
              VStackBlock(spacing: 2, alignment: .fill) {
                UIView.mock(
                  backgroundColor: .layeringColor,
                  preferredSize: .smallSquare
                )
                UIView.mock(
                  backgroundColor: .layeringColor,
                  preferredSize: .smallSquare
                )
              }
            }

          }

        }
        .overlay(
          UILabel.mockMultiline(text: "Mondrian Layout", textColor: .white)
            .viewBlock
            .padding(4)
            .background(
              UIView.mock(
                backgroundColor: .layeringColor
              )
              .viewBlock
            )
            .relative(.bottom, 8)
            .relative(.trailing, 8)
        )

      }
    }
  }
}

var _book_neonGrid: BookView {
  BookPreview {
    ExampleView(width: nil, height: nil) { (view: UIView) in
      Mondrian.buildSubviews(on: view) {

        VStackBlock(spacing: 2, alignment: .fill) {

          UIView.mock(backgroundColor: .neon(.red, .normal), preferredSize: .smallSquare)

          UIView.mock(backgroundColor: .neon(.cyan, .normal), preferredSize: .smallSquare)

          UIView.mock(backgroundColor: .neon(.yellow, .normal), preferredSize: .smallSquare)

          UIView.mock(backgroundColor: .neon(.purple, .normal), preferredSize: .smallSquare)

          UIView.mock(backgroundColor: .neon(.violet, .normal), preferredSize: .smallSquare)

          UIView.mock(backgroundColor: .neon(.pink, .normal), preferredSize: .smallSquare)

          HStackBlock(spacing: 2, alignment: .fill) {

            UIView.mock(backgroundColor: .neon(.red, .brighter), preferredSize: .smallSquare)

            UIView.mock(backgroundColor: .neon(.cyan, .brighter), preferredSize: .smallSquare)

            UIView.mock(backgroundColor: .neon(.yellow, .brighter), preferredSize: .smallSquare)

            UIView.mock(backgroundColor: .neon(.purple, .brighter), preferredSize: .smallSquare)

            UIView.mock(backgroundColor: .neon(.violet, .brighter), preferredSize: .smallSquare)

            UIView.mock(backgroundColor: .neon(.pink, .brighter), preferredSize: .smallSquare)

            VStackBlock(spacing: 2, alignment: .fill) {

              UIView.mock(backgroundColor: .neon(.red, .darker), preferredSize: .smallSquare)

              UIView.mock(backgroundColor: .neon(.cyan, .darker), preferredSize: .smallSquare)

              UIView.mock(backgroundColor: .neon(.yellow, .darker), preferredSize: .smallSquare)

              UIView.mock(backgroundColor: .neon(.purple, .darker), preferredSize: .smallSquare)

              UIView.mock(backgroundColor: .neon(.violet, .darker), preferredSize: .smallSquare)

              UIView.mock(backgroundColor: .neon(.pink, .darker), preferredSize: .smallSquare)
              
            }

            
          }

        }
      }
    }
  }
}
