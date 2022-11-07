//	Created by Leopold Lemmermann on 06.11.22.

import SwiftUI

struct AlertView<Content: View, Actions: View>: View {
  @Binding var isPresented: Bool

  let content: Content,
      actions: (_ dismiss: @escaping () -> Void) -> Actions

  var body: some View {
    ZStack(alignment: .center) {
      if isPresented {
        DimBackgroundView()

        VStack {
          content
          Divider()
          HStack {
            actions(dismiss)
              .frame(maxWidth: .infinity)
          }
        }
        // size
        .padding(5)
        // styling
        .background(.regularMaterial)
        .outline(style)
        .padding(5)
        // gesture
        .offset(x: offset)
        .gesture(dragGesture)
        .animation(.interactiveSpring(), value: offset)
        // transition
        .transition(.slide)
        // preferences
        .onPreferenceChange(update: $style)
      }
    }
    .animation(.default, value: isPresented)
  }

  @State private var style = OutlineStyle()

  @State private var offset = 0.0
  private var dragGesture: some Gesture {
    DragGesture()
      .onChanged { gesture in
        let width = gesture.translation.width
        offset = width > 0 ? width : 0.1 * width
      }
      .onEnded { _ in
        if offset > 50 { dismiss() }
        offset = .zero
      }
  }

  @Environment(\.dismiss) private var dismiss
}

// MARK: - (PREVIEWS)

struct AlertView_Previews: PreviewProvider {
  static var previews: some View {
    Binding.PreviewView(false) { binding in
      Button("Click me show the alert", action: { binding.wrappedValue = true })
        .alert(binding) {
          Text("This is an alert!")
          Text("Some details here.")
        } actions: { dismiss in
          Button("OK") {}
          Button("Cancel", role: .cancel, action: dismiss)
        }
        .onAppear { binding.wrappedValue.toggle() }
        .environment(\.dismiss) { binding.wrappedValue = false }
        .animation(.default, value: binding.wrappedValue)
        .font(.default())
        .previewDisplayName("Default")
    }
  }
}
