//	Created by Leopold Lemmermann on 10.10.22.

import SwiftUI

extension Binding where Value == ColorID {
  var selectionGrid: some View { Value.SelectionGrid(self) }
}

extension ColorID {
  struct SelectionGrid: View {
    @Binding var selection: ColorID

    var body: some View {
      LazyVGrid(columns: [GridItem(.adaptive(minimum: 44))]) {
        ForEach(ColorID.allCases, id: \.self) { colorID in
          colorID
            .selectionButton(
              isSelected: colorID == selection
            ) { selection = colorID }
        }
      }
      .padding(.vertical)
    }

    init(_ selection: Binding<ColorID>) {
      _selection = selection
    }
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
  struct SelectColorGrid_Previews: PreviewProvider {
    static var previews: some View {
      Binding.Preview(ColorID.example) { binding in
        ScrollView {
          ColorID.SelectionGrid(binding)
          binding.selectionGrid
        }
        .padding()
      }
    }
  }
#endif
