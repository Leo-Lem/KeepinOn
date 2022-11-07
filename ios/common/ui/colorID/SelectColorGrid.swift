//	Created by Leopold Lemmermann on 10.10.22.

import SwiftUI

struct SelectColorGrid: View {
  @Binding var colorID: ColorID

  var body: some View {
    LazyVGrid(columns: [GridItem(.adaptive(minimum: 44))]) {
      ForEach(ColorID.allCases, id: \.self) { colorID in
        SelectColorButton(colorID, isSelected: colorID == self.colorID) {
          self.colorID = $0
        }
      }
    }
    .padding(.vertical)
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
struct SelectColorGrid_Previews: PreviewProvider {
  static var previews: some View {
    SelectColorGrid(colorID: .constant(.darkBlue))
  }
}
#endif
