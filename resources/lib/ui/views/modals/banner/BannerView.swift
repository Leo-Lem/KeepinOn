//	Created by Leopold Lemmermann on 06.11.22.

import SwiftUI

struct BannerView<Content: View>: View {
  @Binding var isPresented: Bool

  let dismissAfter: Duration?,
      link: () -> Void,
      content: () -> Content

  var body: some View {
    VStack {
      if isPresented {
        VStack(content: content)
          // sizing
          .frame(maxWidth: .infinity)
          .padding(5)
          // styling
          .background(.regularMaterial)
          .outline(style)
          .padding(5)
          // action
          .onTapGesture {
            link()
            dismiss()
          }
          // gesture
          .offset(y: offset)
          .gesture(dragGesture)
          .animation(.interactiveSpring(), value: offset)
          // transition
          .transition(.offset(y: -100))
          // preferences
          .onPreferenceChange(update: $style)

        Spacer()
      }
    }
    .animation(.default, value: isPresented)
    .task {
      if let dismissAfter = dismissAfter {
        await sleep(for: dismissAfter)
        dismiss()
      }
    }
  }

  @State private var style = OutlineStyle()

  @State private var offset = 0.0
  private var dragGesture: some Gesture {
    DragGesture()
      .onChanged { gesture in
        let height = gesture.translation.height
        offset = height < 0 ? height : 0.1 * height
      }
      .onEnded { _ in
        if -100 ... 0 ~= offset { dismiss() }
        offset = .zero
      }
  }

  @Environment(\.dismiss) private var dismiss
}

// MARK: - (PREVIEWS)

#if DEBUG
struct BannerView_Previews: PreviewProvider {
  static var previews: some View {
    BannerView.Preview {
      Text("You got a notification!").bold()
      Text("Some details go here.")
    }
    .previewDisplayName("Default")

    BannerView.Preview(dismissAfter: .seconds(3)) {
      Text("You got a notification!").bold()
      Text("Some details go here.")
    }
    .previewDisplayName("Dismiss after 3 seconds")
  }
}
#endif
