import MondrianLayout
import StorybookKit
import UIKit

var _book_layoutManager: BookView {
  BookNavigationLink(title: "LayoutManager") {

    let manager = LayoutManager()
    var counter = 0

    BookPreview {
      ExampleView(width: 200, height: 200) { view in

        let box1 = UIView.mock(backgroundColor: .neon(.cyan))
        let box2 = UIView.mock(backgroundColor: .neon(.cyan))
        let box3 = UIView.mock(backgroundColor: .neon(.cyan))

        manager.setup(on: view) {

          if counter % 2 == 0 {

            VStackBlock {
              box1
                .viewBlock
                .size(.smallSquare)

              box2
                .viewBlock
                .size(.smallSquare)

              box3
                .viewBlock
                .size(.smallSquare)

              StackingSpacer(minLength: 0)
            }
          } else {

            HStackBlock {
              box1
                .viewBlock
                .size(.largeSquare)

              box2
                .viewBlock
                .size(.largeSquare)

              box3
                .viewBlock
                .size(.largeSquare)

              StackingSpacer(minLength: 0)
            }
          }

        }

      }
    }
    .addButton(
      "Update",
      handler: { view in
        counter += 1
        manager.reloadLayout()
      }
    )
    .addButton(
      "Update Animated",
      handler: { view in
        counter += 1
        UIViewPropertyAnimator(duration: 1.2, dampingRatio: 0.9) {
          manager.reloadLayout()
          view.layoutIfNeeded()
        }
        .startAnimation()
      }
    )
    .title("LayoutManager")

  }
}
