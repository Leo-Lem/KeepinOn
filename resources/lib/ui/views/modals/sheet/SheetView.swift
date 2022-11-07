//	Created by Leopold Lemmermann on 06.11.22.

import SwiftUI

struct SheetView<Content: View>: View {
  @Binding var isPresented: Bool

  let content: () -> Content

  var body: some View {
    ZStack(alignment: .bottom) {
      if isPresented {
        DimBackgroundView()

        VStack(content: content)
          // sizing
          .if(style.sheet.size == .dynamic) { $0
            .padding(style.sheet.dismissButtonStyle == .top ? .top : .bottom, 40)
          }
          .frame(maxWidth: .infinity)
          .sheetFrame(style.sheet.size)
          // styling
          .background(.regularMaterial)
          .padding(.bottom, 100)
          .outline(style.outline)
          .padding(5)
          .padding(.bottom, -100)
          // dismiss button
          .if(style.sheet.dismissButtonStyle != .hidden) { $0
            .overlay(alignment: style.sheet.dismissButtonStyle == .top ? .top : .bottom) {
              Button(systemImage: "chevron.down", action: dismiss)
                .font(.default(.title2))
                .foregroundColor(style.outline.color)
                .padding(.vertical)
            }
          }
          // gesture
          .offset(y: offset)
          .gesture(dragGesture)
          .animation(.interactiveSpring(), value: offset)
          // transition
          .transition(.move(edge: .bottom))
          // preferences
          .onPreferenceChange(update: $style.sheet)
          .onPreferenceChange(update: $style.outline)
      }
    }
    .animation(.default, value: isPresented)
  }

  @State private var style = (sheet: SheetViewStyle(), outline: OutlineStyle())

  @State private var offset = 0.0
  private var dragGesture: some Gesture {
    DragGesture()
      .onChanged { gesture in
        let height = gesture.translation.height

        offset = height > 0 ? height : 0.1 * height
      }
      .onEnded { _ in
        if offset > 100 { dismiss() }
        offset = .zero
      }
  }

  @Environment(\.dismiss) private var dismiss
}

// MARK: - (PREVIEWS)

struct SheetView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      SheetView.Preview {
        NavigationStack {
          Text("Some Info here!")
          Text("Some details go here.")
            .navigationTitle("Hello there")
            .toolbar { Button(systemImage: "person", action: {}) }
        }
      }
      .previewDisplayName("Default")

      SheetView.Preview {
        Text("Some Info here!")
        Text("Some details go here.")
          .preferred(style: SheetViewStyle(size: .half))
      }
      .previewDisplayName("Half sheet")

      SheetView.Preview {
        Text("Some Info here!")
        Text("Some details go here.")
          .preferred(style: SheetViewStyle(size: .dynamic))
      }
      .previewDisplayName("Dynamic")

      SheetView.Preview {
        Text("Some Info here!")
        Text("Some details go here.")
          .preferred(style: SheetViewStyle(size: .fixed(200)))
      }
      .previewDisplayName("Fixed")

      SheetView.Preview {
        Text("Some Info here!")
        Text("Some details go here.")
          .preferred(style: SheetViewStyle(size: .fraction(0.7)))
      }
      .previewDisplayName("Fraction")
    }
  }
}
