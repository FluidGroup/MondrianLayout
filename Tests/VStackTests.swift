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

final class VStackTests: XCTestCase {

  func test_mixing_spacer() {
    let view = ExampleView(width: nil, height: 180) { (view: UIView) in
      view.mondrian.buildSubviews {
        VStackBlock(spacing: 4) {
          UIView.mock(
            backgroundColor: .layeringColor,
            preferredSize: .smallSquare
          )

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

  func test_enter() {

    let view = ExampleView(width: nil, height: nil) { (view: UIView) in
      view.mondrian.buildSubviews {
        VStackBlock(spacing: 4, alignment: .center) {
          UILabel.mockMultiline(text: "Hello", textColor: .white)
            .viewBlock
            .padding(8)
            .background(UIView.mock(backgroundColor: .layeringColor))
          UILabel.mockMultiline(text: "Mondrian", textColor: .white)
            .viewBlock
            .padding(8)
            .background(UIView.mock(backgroundColor: .layeringColor))
          UILabel.mockMultiline(text: "Layout!", textColor: .white)
            .viewBlock
            .padding(8)
            .background(UIView.mock(backgroundColor: .layeringColor))
        }
      }
    }

    assertSnapshot(matching: view, as: .image, record: _record)

  }

  func test_leading() {

    let view = ExampleView(width: nil, height: nil) { (view: UIView) in
      view.mondrian.buildSubviews {
        VStackBlock(spacing: 4, alignment: .leading) {
          UILabel.mockMultiline(text: "Hello", textColor: .white)
            .viewBlock
            .padding(8)
            .background(UIView.mock(backgroundColor: .layeringColor))
          UILabel.mockMultiline(text: "Mondrian", textColor: .white)
            .viewBlock
            .padding(8)
            .background(UIView.mock(backgroundColor: .layeringColor))
          UILabel.mockMultiline(text: "Layout!", textColor: .white)
            .viewBlock
            .padding(8)
            .background(UIView.mock(backgroundColor: .layeringColor))
        }
      }
    }

    assertSnapshot(matching: view, as: .image, record: _record)

  }

  func test_trailing() {

    let view = ExampleView(width: nil, height: nil) { (view: UIView) in
      view.mondrian.buildSubviews {
        VStackBlock(spacing: 4, alignment: .trailing) {
          UILabel.mockMultiline(text: "Hello", textColor: .white)
            .viewBlock
            .padding(8)
            .background(UIView.mock(backgroundColor: .layeringColor))
          UILabel.mockMultiline(text: "Mondrian", textColor: .white)
            .viewBlock
            .padding(8)
            .background(UIView.mock(backgroundColor: .layeringColor))
          UILabel.mockMultiline(text: "Layout!", textColor: .white)
            .viewBlock
            .padding(8)
            .background(UIView.mock(backgroundColor: .layeringColor))
        }
      }
    }

    assertSnapshot(matching: view, as: .image, record: _record)

  }

  func test_additional_spacing() {

    let view = ExampleView(width: nil, height: nil) { (view: UIView) in
      view.mondrian.buildSubviews {
        VStackBlock(spacing: 4) {
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

  func test_label_alignment() {

    let view = ExampleView(width: 200, height: 200) { (view: UIView) in
      view.mondrian.buildSubviews {
        VStackBlock(alignment: .leading) {
          UILabel.mockMultiline(text: "Hello")
            .viewBlock
            .padding(.horizontal, 10)
          UIView.mock(backgroundColor: .layeringColor)
            .viewBlock
            .alignSelf(.fill)
        }
        .background(UIView.mock(backgroundColor: .layeringColor))
      }
    }

    assertSnapshot(matching: view, as: .image, record: _record)

  }

}
