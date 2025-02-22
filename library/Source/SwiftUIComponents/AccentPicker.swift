// Created by Leopold Lemmermann on 22.02.25.

import Data

public struct AccentPicker: View {
  @Binding public var accent: Accent

  public var body: some View {
    LazyVGrid(columns: [GridItem(.adaptive(minimum: 50))]) {
      ForEach(Accent.allCases, id: \.self) { accent in
        Button(accent.a11y, systemImage: "checkmark.circle") {
          self.accent = accent
        }
        .buttonStyle(.borderless)
        .labelStyle(.iconOnly)
        .imageScale(.large)
        .padding()
        .foregroundColor(accent == self.accent ? .primary : .clear)
        .background(accent.color, in: .rect(cornerRadius: 10))
        .accessibilityAddTraits(accent == self.accent ? .isSelected : .allowsDirectInteraction)
      }
    }
    .accessibilityElement(children: .ignore)
    .accessibilityLabel(.localizable(.pickColor))
    .accessibilityValue(accent.a11y)
  }

  public init(_ accent: Binding<Accent>) { _accent = accent }
}

#Preview {
  @Previewable @State var accent = Accent.blue

  AccentPicker($accent)
}
