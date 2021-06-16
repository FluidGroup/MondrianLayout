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
              preferredSize: .init(width: 28, height: 28)
            )

            UIView.mock(
              backgroundColor: .layeringColor,
              preferredSize: .init(width: 28, height: 50)
            )

            UIView.mock(
              backgroundColor: .mondrianYellow,
              preferredSize: .init(width: 28, height: 28)
            )

            UIView.mock(
              backgroundColor: .layeringColor,
              preferredSize: .init(width: 28, height: 28)
            )

            HStackBlock(alignment: .fill) {
              UIView.mock(
                backgroundColor: .layeringColor,
                preferredSize: .init(width: 28, height: 28)
              )
              UIView.mock(
                backgroundColor: .layeringColor,
                preferredSize: .init(width: 28, height: 28)
              )
            }
          }

          VStackBlock(spacing: 2, alignment: .fill) {
            HStackBlock(spacing: 2, alignment: .fill) {
              UIView.mock(
                backgroundColor: .layeringColor,
                preferredSize: .init(width: 28, height: 28)
              )
              VStackBlock(spacing: 2, alignment: .fill) {
                HStackBlock(spacing: 2, alignment: .fill) {
                  UIView.mock(
                    backgroundColor: .mondrianYellow,
                    preferredSize: .init(width: 28, height: 28)
                  )
                  UIView.mock(
                    backgroundColor: .layeringColor,
                    preferredSize: .init(width: 28, height: 28)
                  )
                }
                UIView.mock(
                  backgroundColor: .layeringColor,
                  preferredSize: .init(width: 28, height: 28)
                )
              }
            }

            HStackBlock(spacing: 2, alignment: .fill) {
              VStackBlock(spacing: 2, alignment: .fill) {
                UIView.mock(
                  backgroundColor: .layeringColor,
                  preferredSize: .init(width: 28, height: 28)
                )
                UIView.mock(
                  backgroundColor: .mondrianBlue,
                  preferredSize: .init(width: 28, height: 28)
                )
              }

              UIView.mock(
                backgroundColor: .layeringColor,
                preferredSize: .init(width: 28, height: 28)
              )

              VStackBlock(spacing: 2, alignment: .fill) {
                UIView.mock(
                  backgroundColor: .layeringColor,
                  preferredSize: .init(width: 28, height: 28)
                )
                UIView.mock(
                  backgroundColor: .layeringColor,
                  preferredSize: .init(width: 28, height: 28)
                )
              }
            }

            HStackBlock(spacing: 2, alignment: .fill) {
              UIView.mock(
                backgroundColor: .mondrianRed,
                preferredSize: .init(width: 28, height: 28)
              )
              VStackBlock(spacing: 2, alignment: .fill) {
                UIView.mock(
                  backgroundColor: .layeringColor,
                  preferredSize: .init(width: 28, height: 28)
                )
                UIView.mock(
                  backgroundColor: .layeringColor,
                  preferredSize: .init(width: 28, height: 28)
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
