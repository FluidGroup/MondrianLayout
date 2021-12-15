import MondrianLayout
import StorybookKit
import UIKit

var _book_classic: BookView {
  BookNavigationLink(title: "Classic") {

    BookPreview {
      ExampleView(width: nil, height: nil) { view in

        let box1 = UIView.mock(preferredSize: .init(width: 30, height: 30))
        let box2 = UIView.mock(preferredSize: .init(width: 30, height: 30))

        view.addSubview(box1)
        view.addSubview(box2)

        Mondrian.layout {

          box1.mondrian.layout
            .top(.toSuperview, .min(0))
            .left(.toSuperview)
            .right(.to(box2).left)
            .bottom(.to(box2).bottom)

          box2.mondrian.layout
            .top(.toSuperview.top)
            .height(.to(box1).height, multiplier: 2)
            .right(.toSuperview)
            .bottom(.toSuperview)

        }
      }
    }

    BookPreview {
      ExampleView(width: nil, height: nil) { view in

        let label1 = UILabel.mockSingleline(text: "Hello")
        let label2 = UILabel.mockSingleline(text: "Hello")

        view.addSubview(label1)
        view.addSubview(label2)

        mondrianBatchLayout {

          label1.mondrian.layout
            .top(.toSuperview)
            .left(.toSuperview)
            .right(.to(label2).left)
            .bottom(.to(label2).bottom)

          label2.mondrian.layout
            .top(.toSuperview.top, .exact(10))
            .right(.toSuperview)
            .bottom(.toSuperview)

        }
      }
    }

    BookPreview {
      ExampleView(width: nil, height: nil) { view in

        let box1 = UIView.mock(backgroundColor: .mondrianBlue, preferredSize: .smallSquare)
        let box2 = UIView.mock(backgroundColor: .mondrianBlue, preferredSize: .smallSquare)

        view.addSubview(box1)
        view.addSubview(box2)

        mondrianBatchLayout {

          box1.mondrian.layout
            .top(.toSuperview)
            .left(.toSuperview)
            .right(.to(box2).left)
            .bottom(.to(box2).bottom)

          box2.mondrian.layout
            .top(.toSuperview.top, .exact(10))
            .right(.toSuperview)
            .bottom(.toSuperview)

        }
      }
    }

    BookPreview {
      ExampleView(width: nil, height: nil) { view in

        let containerCenterDemo = UIView.mock(backgroundColor: .mondrianGray, preferredSize: .largeSquare)
        let containeeCenterDemo = UIView.mock(backgroundColor: .mondrianBlue, preferredSize: .smallSquare)

        view.addSubview(containerCenterDemo)

        containerCenterDemo.addSubview(containeeCenterDemo)

        mondrianBatchLayout {

          containerCenterDemo.mondrian.layout
            .edges(.toSuperview)

          containeeCenterDemo.mondrian.layout
            .center(.toSuperview)

        }
      }
    }

    BookPreview {
      ExampleView(width: nil, height: nil) { view in

        let containerEdgesDemo = UIView.mock(backgroundColor: .mondrianYellow, preferredSize: .largeSquare)
        let containeeEdgesDemo = UIView.mock(backgroundColor: .mondrianBlue)

        view.addSubview(containerEdgesDemo)

        containerEdgesDemo.addSubview(containeeEdgesDemo)

        mondrianBatchLayout {

          containerEdgesDemo.mondrian.layout
            .edges(.toSuperview)

          containeeEdgesDemo.mondrian.layout
            .edges(.toSuperview, .exact(8))
        }
      }
    }

    BookSection(title: "Comparing using this library or not") {
      BookPreview {
        ExampleView(width: nil, height: nil) { (view: UIView) in

          let backgroundView = UIView.mock(backgroundColor: .neon(.violet))
          let box1 = UIView.mock(backgroundColor: .neon(.red), preferredSize: .largeSquare)
          let box2 = UIView.mock(backgroundColor: .neon(.yellow), preferredSize: .largeSquare)

          view.addSubview(backgroundView)
          view.addSubview(box1)
          view.addSubview(box2)

          backgroundView.translatesAutoresizingMaskIntoConstraints = false
          box1.translatesAutoresizingMaskIntoConstraints = false
          box2.translatesAutoresizingMaskIntoConstraints = false

          NSLayoutConstraint.activate([

            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.leftAnchor.constraint(equalTo: view.leftAnchor),
            backgroundView.rightAnchor.constraint(equalTo: view.rightAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            box1.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            box1.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            box1.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),

            box2.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            box2.leftAnchor.constraint(equalTo: box1.rightAnchor, constant: 10),
            box2.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),
            box2.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10)
          ])

        }
      }
      .title("From plain API")

      BookPreview {
        ExampleView(width: nil, height: nil) { (view: UIView) in

          let backgroundView = UIView.mock(backgroundColor: .neon(.violet))
          let box1 = UIView.mock(backgroundColor: .neon(.red), preferredSize: .largeSquare)
          let box2 = UIView.mock(backgroundColor: .neon(.yellow), preferredSize: .largeSquare)

          Mondrian.buildSubviews(on: view) {
            HStackBlock(spacing: 10) {
              box1
              box2
            }
            .padding(10)
            .background(backgroundView)
          }

        }
      }
      .title("With Structured layout")

      BookPreview {
        ExampleView(width: nil, height: nil) { (view: UIView) in

          let backgroundView = UIView.mock(backgroundColor: .neon(.violet))
          let box1 = UIView.mock(backgroundColor: .neon(.red), preferredSize: .largeSquare)
          let box2 = UIView.mock(backgroundColor: .neon(.yellow), preferredSize: .largeSquare)

          view.addSubview(backgroundView)
          view.addSubview(box1)
          view.addSubview(box2)

          mondrianBatchLayout {

            backgroundView.mondrian.layout.edges(.toSuperview)

            box1.mondrian.layout
              .top(.toSuperview, 10)
              .left(.toSuperview, 10)
              .bottom(.toSuperview, 10)

            box2.mondrian.layout
              .top(.toSuperview, 10)
              .left(.to(box1).right, 10)
              .right(.toSuperview, 10)
              .bottom(.toSuperview, 10)

          }

        }
      }
      .title("With classic style")
    }


  }
}
