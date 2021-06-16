//
//  OverlayTests.swift
//  Tests
//
//  Created by Muukii on 2021/06/16.
//

import Foundation
import MondrianLayout
import SnapshotTesting
import XCTest

final class OverlayTests: XCTestCase {

  func test_1() {

    let view = ExampleView(width: nil, height: nil) { (view: UIView) in
      view.buildSublayersLayout {
        UIView.mock(
          backgroundColor: .layeringColor,
          preferredSize: .init(width: 100, height: 100)
        )
        .viewBlock
        .overlay(
          UIView.mock(backgroundColor: .layeringColor)
            .viewBlock
            .overlay(
              UIView.mock(backgroundColor: .layeringColor)
                .viewBlock
                .padding(10)
            )
            .padding(10)
        )
      }
    }

    assertSnapshot(matching: view, as: .image, record: _record)

  }

  func test_2() {

    let view = ExampleView(width: nil, height: nil) { (view: UIView) in
      view.buildSublayersLayout {
        VStackBlock {
          UIView.mock(
            preferredSize: .init(width: 28, height: 28)
          )
          UIView.mock(
            preferredSize: .init(width: 28, height: 28)
          )
          UIView.mock(
            preferredSize: .init(width: 28, height: 28)
          )
        }
        .padding(10)
        .overlay(UIView.mock(backgroundColor: .layeringColor))
      }
    }

    XCTAssertFalse(view.hasAmbiguousLayoutRecursively)
    assertSnapshot(matching: view, as: .image, record: _record)

  }

}
