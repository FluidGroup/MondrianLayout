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

  func test_expandsElementIfCanBeExpanding() {

    let view = ExampleView(width: 100, height: 100) { view in
      view.mondrian.buildSublayersLayout {
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
      view.mondrian.buildSublayersLayout {
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
}
