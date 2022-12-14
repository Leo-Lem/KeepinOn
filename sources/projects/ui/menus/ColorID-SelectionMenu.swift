//  Created by Leopold Lemmermann on 10.10.22.

import Colors
import Previews
import SwiftUI

extension ColorID {
  struct SelectionMenu: View {
    @Binding var colorID: ColorID

    public var body: some View {
      LazyVGrid(columns: [GridItem(.adaptive(minimum: 50))]) {
        ForEach(ColorID.allCases, id: \.self) { colorID in
          Button { self.colorID = colorID } label: {
            Label(colorID.a11y, systemImage: "checkmark.circle")
              .labelStyle(.iconOnly)
              .imageScale(.large)
              .foregroundColor(colorID == self.colorID ? .primary : .clear)
              .padding()
              .background { colorID.color }
              .aspectRatio(1 / 1, contentMode: .fill)
              .cornerRadius(10)
          }
          .buttonStyle(.borderless)
          .if(colorID == self.colorID) { $0.accessibilityAddTraits(.isSelected) }
          .id(colorID)
        }
      }
      .accessibilityElement(children: .ignore)
      .accessibilityLabel("ACCOUNT_SELECT_COLOR")
      .accessibilityValue(colorID.a11y)
    }

    init(_ colorID: Binding<ColorID>) { _colorID = colorID }
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
struct ColorIDSelectionMenu_Previews: PreviewProvider {
  static var previews: some View {
    Binding.Preview(ColorID.example) { binding in
      ColorID.SelectionMenu(binding)
    }
  }
}
#endif
