//	Created by Leopold Lemmermann on 07.11.22.

import SwiftUI

extension AlertView {
  struct Preview: View {
    @ViewBuilder let content: () -> Content,
                     actions: (@escaping () -> Void) -> Actions

    var body: some View {
      Binding.PreviewView(false) { binding in
        Button("Click me to display the alert!") { binding.wrappedValue = true }
          .alert(binding, content: content, actions: actions)
          .onAppear { binding.wrappedValue = true }
          .environment(\.dismiss) { binding.wrappedValue = false }
      }
    }
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
struct AlertViewPreview_Previews: PreviewProvider {
  static var previews: some View {
    AlertView.Preview {
      Text("Hello there")
    } actions: { dismiss in
      Button("Ok") { dismiss() }
    }
  }
}
#endif
