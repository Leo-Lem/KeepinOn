//	Created by Leopold Lemmermann on 07.11.22.

import SwiftUI

extension SheetView {
  struct Preview: View {
    @ViewBuilder let content: () -> Content

    var body: some View {
      Binding.PreviewView(false) { binding in
        Button("Click me to display the sheet!") { binding.wrappedValue = true }
          .sheet(binding, content: content)
          .onAppear { binding.wrappedValue = true }
          .environment(\.dismiss) { binding.wrappedValue = false }
      }
    }
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
struct SheetViewPreview_Previews: PreviewProvider {
  static var previews: some View {
    SheetView.Preview {
      Text("Hello there")
    }
  }
}
#endif
