import SwiftUI

@available(iOS 13, *)
enum Padding {

  struct ContentView: View {

    var body: some View {
      BorderedRect()
        .frame(maxWidth: 100, maxHeight: 100)
        .foregroundColor(.init(white: 0, opacity: 0.2))
        .overlay(
          BorderedRect()
            .foregroundColor(.init(white: 0, opacity: 0.2))
            .overlay(
              BorderedRect()
                .foregroundColor(.init(white: 0, opacity: 0.2))
                .padding(10)
            )
            .padding(10)
        )

    }
  }

  struct BorderedRect: View {

    var body: some View {
      Rectangle()
        .border(Color(white: 0, opacity: 0.2), width: 3)
        .foregroundColor(.init(white: 0, opacity: 0.2))
    }
  }

  enum Preview: PreviewProvider {

    static var previews: some View {

      Group {

        Group {
          VStack {
            Text("Financial Results")
              .font(.title)
              .background(BorderedRect())

            HStack(alignment: .center) {
              Text("Q1 Sales")
                .font(.headline)
                .frame(maxHeight: .infinity)
                .background(BorderedRect())


              VStack {
                Text("January")
                Text("February")
                Text("March")
              }
              .background(BorderedRect())

              VStack {
                Text("$1000")
                Text("$200")
                Text("$3000")
              }
              .background(BorderedRect())
            }
          }
        }

        ContentView()

      }
    }

  }

}
