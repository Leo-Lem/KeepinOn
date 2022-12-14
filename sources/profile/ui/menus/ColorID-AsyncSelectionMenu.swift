//	Created by Leopold Lemmermann on 10.10.22.

import Colors
import LeosMisc
import SwiftUI

extension ColorID {
  struct AsyncSelectionMenu: View {
    let colorID: ColorID
    let save: (ColorID) async -> Void
    
    var body: some View {
      LazyVGrid(columns: [GridItem(.adaptive(minimum: 50))]) {
        ForEach(ColorID.allCases, id: \.self) { colorID in
          AsyncButton(indicatorStyle: .replace, taskPriority: .userInitiated) { await save(colorID) } label: {
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
        }
      }
      .accessibilityElement(children: .ignore)
      .accessibilityLabel("ACCOUNT_SELECT_COLOR")
      .accessibilityValue(self.colorID.a11y)
    }
    
    init(_ colorID: ColorID, saveColorID: @escaping (ColorID) async -> Void) {
      (self.colorID, self.save) = (colorID, saveColorID)
    }
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
struct ColorIDAsyncSelectionMenuView_Previews: PreviewProvider {
  static var previews: some View {
    ColorID.AsyncSelectionMenu(.gold) {_ in}.presentPreview()
  }
}
#endif
