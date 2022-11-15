//	Created by Leopold Lemmermann on 30.10.22.

import SwiftUI

extension ColorID {
  func selectionButton(isSelected: Bool, select: @escaping () -> Void) -> some View {
    SelectionButton(self, isSelected: isSelected, select: select)
  }

  struct SelectionButton: View {
    let colorID: ColorID,
        isSelected: Bool,
        select: () -> Void

    var body: some View {
      Button(systemImage: "checkmark.circle") { select() }
        .buttonStyle(.borderless) // otherwise the buttons can't be individually clicked in a list
        .font(.default(.largeTitle))
        .foregroundColor(isSelected ? .primary : .clear)
        .padding(5)
        .background {
          colorID.color
            .aspectRatio(1, contentMode: .fit)
            .cornerRadius(10)
        }
        .if(isSelected) { $0.accessibilityAddTraits(.isSelected) }
        .accessibilityLabel(colorID.a11y)
    }

    init(_ colorID: ColorID, isSelected: Bool, select: @escaping () -> Void) {
      self.colorID = colorID
      self.isSelected = isSelected
      self.select = select
    }
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
  struct SelectColorButton_Previews: PreviewProvider {
    static var previews: some View {
      ScrollView(.horizontal) {
        HStack {
          ForEach(ColorID.allCases, id: \.self) { colorID in
            colorID.selectionButton(isSelected: .random()) {}
          }
        }
        .padding()
      }
    }
  }
#endif
