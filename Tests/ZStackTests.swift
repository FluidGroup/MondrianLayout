//
//  ZStackTests.swift
//  Tests
//
//  Created by Muukii on 2021/06/18.
//

import Foundation
import MondrianLayout
import SnapshotTesting
import XCTest

final class ZStackTests: XCTestCase {

  func test_minimum_padding() {

    let view = ExampleView(width: 100, height: 100) { view in
      Mondrian.buildSubviews(on: view) {
        ZStackBlock {
          ZStackBlock {
            UILabel.mockSingleline(text: "Hello Hello Hello")
              .viewBlock
              .background(UIView.mock())
          }
          .padding(20) /// a minimum padding for the label in the container
        }
        .background(UIView.mock())
      }
    }

    assertSnapshot(matching: view, as: .image, record: _record)

  }

  func test_expandsElementIfCanBeExpanding() {

    let view = ExampleView(width: 100, height: 100) { view in
      Mondrian.buildSubviews(on: view) {
        LayoutContainer(attachedSafeAreaEdges: .vertical) {
          ZStackBlock {

            /// this view must be expanded to parent view
            UIView.mock(
              backgroundColor: .layeringColor
            )

            /// this view must be sized with intrinsic content size.
            UIView.mock(
              backgroundColor: .layeringColor,
              preferredSize: .smallSquare
            )
          }
        }
      }
    }

    assertSnapshot(matching: view, as: .image, record: _record)

  }

  func test_expandsElementWithRelative() {

    let view = ExampleView(width: 100, height: 100) { view in
      Mondrian.buildSubviews(on: view) {
        LayoutContainer(attachedSafeAreaEdges: .vertical) {
          ZStackBlock {
            UIView.mock(
              backgroundColor: .layeringColor,
              preferredSize: .smallSquare
            )
            .viewBlock
            .relative(0)
          }
        }
      }
    }

    assertSnapshot(matching: view, as: .image, record: _record)
  }

  func test_alignSelf() {

    let view = ExampleView(width: 100, height: 100) { view in
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

    assertSnapshot(matching: view, as: .image, record: _record)

  }
}
