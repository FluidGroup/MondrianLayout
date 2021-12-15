//
//  Tests.swift
//  Tests
//
//  Created by Muukii on 2021/06/13.
//

import XCTest
import MondrianLayout
import SnapshotTesting

let _record = ProcessInfo().environment["RECORD"] != nil

final class LayoutSnapshotTests: XCTestCase {

  func test_1() {

    let view = ExampleView(width: 100, height: 100) { view in
      Mondrian.buildSubviews(on: view) {
        VStackBlock {
          ZStackBlock {
            UIView.mock(
              backgroundColor: .layeringColor,
              preferredSize: .init(width: 100, height: 100)
            )

            UIView.mock(
              backgroundColor: .layeringColor,
              preferredSize: .init(width: 10, height: 10)
            )
            .viewBlock
            .relative([.top, .trailing], 10)

          }
        }
      }
    }

    assertSnapshot(matching: view, as: .image, record: _record)

  }

  func test_mondrian() {

    let view = ExampleView(width: 200, height: 200) { (view: UIView) in
      Mondrian.buildSubviews(on: view) {

        HStackBlock(spacing: 2, alignment: .fill) {
          VStackBlock(spacing: 2, alignment: .fill) {
            UIView.mock(
              backgroundColor: .layeringColor,
              preferredSize: .smallSquare
            )

            UIView.mock(
              backgroundColor: .layeringColor,
              preferredSize: .init(width: 28, height: 50)
            )

            UIView.mock(
              backgroundColor: .layeringColor,
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
                    backgroundColor: .layeringColor,
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
                  backgroundColor: .layeringColor,
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
            .relative([.bottom, .trailing], 10)
        )

      }
    }

    assertSnapshot(matching: view, as: .image, record: _record)
  }

}

/*
@discardableResult
func layout<Content: ConstraintLayoutElementType>(
  @LayoutConstraintBuilder _ c: () -> Content
) -> Content {
  c()
}

class Tests: XCTestCase {

  func test_pattern_stack() {

    _ = layout {
      HStackBlock {
        UIView()
      }
    }

    _ = layout {
      HStackBlock {
        UIView()
        StackSpacer(minLength: 0)
      }
    }

  }

  func test_pattern1() {

    _ = layout {
      HStackBlock {
//        VStackBlock {
//          UIView()
//        }
      }
    }

  }

  func test_pattern2() {

    _ = layout {
      HStackBlock {
        UIView()
//        VStackBlock {}
      }
    }

  }

  func test_pattern3() {

    _ = layout {
      HStackBlock {
        UIView()
        UIView()
      }
    }

  }
}
*/
