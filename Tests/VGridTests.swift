//
//  VGridTests.swift
//  Tests
//
//  Created by Muukii on 2021/12/15.
//

import Foundation
import MondrianLayout
import SnapshotTesting
import XCTest

final class VGridTests: XCTestCase {

  func test_basic() {

    let view = ExampleView(width: 100, height: nil) { view in
      Mondrian.buildSubviews(on: view) {
        VGridBlock(
          columns: [
            .init(.flexible(), spacing: 16),
            .init(.flexible(), spacing: 16),
          ],
          spacing: 4
        ) {

          UILabel.mockMultiline(text: "Helloooo")
            .viewBlock
            .overlay(UIView.mock(backgroundColor: .layeringColor, preferredSize: .smallSquare))

          UIView.mock(backgroundColor: .layeringColor, preferredSize: .smallSquare)
          UIView.mock(backgroundColor: .layeringColor, preferredSize: .smallSquare)
          UIView.mock(backgroundColor: .layeringColor, preferredSize: .smallSquare)

          UIView.mock(backgroundColor: .layeringColor, preferredSize: .smallSquare)
          UIView.mock(backgroundColor: .layeringColor, preferredSize: .smallSquare)
          UIView.mock(backgroundColor: .layeringColor, preferredSize: .smallSquare)
          UIView.mock(backgroundColor: .layeringColor, preferredSize: .smallSquare)

          UIView.mock(backgroundColor: .layeringColor, preferredSize: .smallSquare)
          UIView.mock(backgroundColor: .layeringColor, preferredSize: .smallSquare)
        }
      }
    }

    assertSnapshot(matching: view, as: .image, record: _record)

  }
}
