//	Created by Leopold Lemmermann on 30.10.22.

import SwiftUI

struct SelectColorButton: View {
  let colorID: ColorID,
      isSelected: Bool,
      select: (ColorID) -> Void

  var body: some View {
    Button(systemImage: "checkmark.circle") { select(colorID) }
      .buttonStyle(.borderless) // otherwise the buttons can't be individually clicked in a list
      .font(.default(.largeTitle))
      .foregroundColor(isSelected ? .primary : .clear)
      .padding(5)
      .background {
        colorID.color
          .aspectRatio(1, contentMode: .fit)
          .cornerRadius(6)
      }
      .if(isSelected) { $0.accessibilityAddTraits(.isSelected) }
      .accessibilityLabel(colorID.a11y)
  }

  init(_ colorID: ColorID, isSelected: Bool, select: @escaping (ColorID) -> Void) {
    self.colorID = colorID
    self.isSelected = isSelected
    self.select = select
  }
}

// MARK: - (PREVIEWS)

struct SelectColorButton_Previews: PreviewProvider {
  static var previews: some View {
    SelectColorButton(.darkBlue, isSelected: false) { _ in }
  }
}
