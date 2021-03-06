//
//  Extensions.swift
//  Demo_BoxLayout2
//
//  Created by Muukii on 2021/06/13.
//

import UIKit

extension UIView {

  static func mock(backgroundColor: UIColor = .layeringColor) -> UIView {
    let view = UIView()
    view.backgroundColor = backgroundColor
    view.layer.borderWidth = 3
    view.layer.borderColor = UIColor(white: 0, alpha: 0.2).cgColor
    return view
  }

  static func mock(backgroundColor: UIColor = .layeringColor, preferredSize: CGSize) -> UIView {
    let view = IntrinsicSizeView(preferredSize: preferredSize)
    view.backgroundColor = backgroundColor
    view.layer.borderWidth = 3
    view.layer.borderColor = UIColor(white: 0, alpha: 0.2).cgColor
    return view
  }
}

extension UIImageView {

  static func mock(image: UIImage) -> UIView {
    let view = UIImageView(image: image)
    return view

  }
}

final class IntrinsicSizeView: UIView {

  private let preferredSize: CGSize

  init(
    preferredSize: CGSize
  ) {
    self.preferredSize = preferredSize
    super.init(frame: .zero)
  }

  required init?(
    coder: NSCoder
  ) {
    fatalError("init(coder:) has not been implemented")
  }

  override var intrinsicContentSize: CGSize {
    preferredSize
  }

}

extension UILabel {

  static func mockSingleline(text: String, textColor: UIColor = .black) -> UILabel {
    let label = UILabel()
    label.font = .preferredFont(forTextStyle: .headline)
    label.textColor = textColor
    label.numberOfLines = 1
    label.text = text
    return label
  }

  static func mockMultiline(text: String, textColor: UIColor = .black) -> UILabel {
    let label = UILabel()
    label.font = .preferredFont(forTextStyle: .headline)
    label.textColor = textColor
    label.numberOfLines = 0
    label.text = text
    return label
  }
}
