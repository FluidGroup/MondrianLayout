import MondrianLayout
import StorybookKit
import UIKit

let book = Book(title: "MondrianLayout") {

  _book_neonGrid

  _book_mondrian

  _book_sizing

  _book_background

  _book_overlay

  _book_VStackBlock

  _book_HStackBlock

  _book_ZStackConstraint

  _book_VGridConstraint

  _book_RelativeBlock

  _book_SafeArea

  _book_ViewController

  _book_classic

  _book_layoutManager

  BookNavigationLink(title: "Instagram Post") {
    BookPreview {
      InstagramPostView()
    }
  }
}
