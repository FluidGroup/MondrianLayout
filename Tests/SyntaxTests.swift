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

final class SyntaxTests: XCTestCase {

  func test_vStack() {

    let view = ExampleView(width: 20, height: nil) { view in
      view.buildSublayersLayout(safeArea: .vertical) {
        VStackBlock {

          UIView.mock(backgroundColor: .layeringColor)
            .viewBlock
            .height(10)
            .spacingBefore(10)

          UIView.mock(backgroundColor: .layeringColor)
            .viewBlock
            .height(10)
            .spacingAfter(10)

          UIView.mock(backgroundColor: .layeringColor)
            .viewBlock
            .height(10)
            .spacingAfter(10)
            .spacingAfter(10)
            .spacingBefore(10)
            .spacingBefore(10)

        }
        .background(UIView.mock(backgroundColor: .layeringColor))
      }
    }

    XCTAssertEqual(view.frame.height, 90)
    assertSnapshot(matching: view, as: .image, record: true)

  }

  func test_hStack() {

    let view = ExampleView(width: nil, height: 20) { view in
      view.buildSublayersLayout(safeArea: .vertical) {
        HStackBlock {

          UIView.mock(backgroundColor: .layeringColor)
            .viewBlock
            .width(10)
            .spacingBefore(10)

          UIView.mock(backgroundColor: .layeringColor)
            .viewBlock
            .width(10)
            .spacingAfter(10)

          UIView.mock(backgroundColor: .layeringColor)
            .viewBlock
            .width(10)
            .spacingAfter(10)
            .spacingAfter(10)
            .spacingBefore(10)
            .spacingBefore(10)

        }
        .background(UIView.mock(backgroundColor: .layeringColor))
      }
    }

    XCTAssertEqual(view.frame.width, 90)
    assertSnapshot(matching: view, as: .image, record: true)

  }

}
