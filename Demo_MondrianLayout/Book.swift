import MondrianLayout
import StorybookKit
import UIKit

let book = Book(title: "MondrianLayout") {

  _book_neonGrid

  _book_mondrian

  _book_background

  _book_overlay

  _book_VStackBlock

  _book_HStackBlock

  _book_ZStackConstraint

  _book_SafeArea

  _book_ViewController

  _book_classic

  BookNavigationLink(title: "Instagram Post") {
    BookPreview {
      InstagramPostView()
    }
  }
}
