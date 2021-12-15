//
//  HStackTests.swift
//  Tests
//
//  Created by Muukii on 2021/06/17.
//

import Foundation
import MondrianLayout
import SnapshotTesting
import XCTest

final class HStackTests: XCTestCase {

  func test_mixing_spacer() {

    let view = ExampleView(width: 180, height: nil) { (view: UIView) in
      Mondrian.buildSubviews(on: view) {
        HStackBlock(spacing: 4) {
          UIView.mock(
            backgroundColor: .layeringColor,
            preferredSize: .smallSquare
          ) as UIView?

          StackingSpacer(minLength: 20)

          UIView.mock(
            backgroundColor: .layeringColor,
            preferredSize: .smallSquare
          )

          UIView.mock(
            backgroundColor: .layeringColor,
            preferredSize: .smallSquare
          )

          StackingSpacer(minLength: 20, expands: false)
        }
        .background(UIView.mock(backgroundColor: .layeringColor))
      }
    }

    assertSnapshot(matching: view, as: .image, record: _record)

  }

  func test_additional_spacing() {

    let view = ExampleView(width: nil, height: nil) { (view: UIView) in
      Mondrian.buildSubviews(on: view) {
        HStackBlock(spacing: 4) {
          UIView.mock(
            preferredSize: .smallSquare
          )

          StackingSpacer(minLength: 4)

          UIView.mock(
            preferredSize: .smallSquare
          )

          UIView.mock(
            preferredSize: .smallSquare
          )
        }
      }
    }

    assertSnapshot(matching: view, as: .image, record: _record)
  }
}
