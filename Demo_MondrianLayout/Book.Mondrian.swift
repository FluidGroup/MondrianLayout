import StorybookKit
import UIKit

import MondrianLayout

var _book_mondrian: BookView {
  BookPreview {
    ExampleView(width: 200, height: 200) { (view: UIView) in
      view.buildSublayersLayout {

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
            .relative(bottom: 8, right: 8)
        )

      }
    }
  }
}
