//	Created by Leopold Lemmermann on 10.10.22.

import Previews
import SwiftUI

@available(iOS 15, macOS 12, *)
public extension Binding where Value == ColorID {
  var selectionGrid: some View { Value.SelectionGrid(self) }
}

@available(iOS 15, macOS 12, *)
public extension ColorID {
  struct SelectionGrid: View {
    @Binding var selection: ColorID

    public var body: some View {
      LazyVGrid(columns: Array(repeating: GridItem(.adaptive(minimum: 50)), count: 5)) {
        ForEach(ColorID.allCases, id: \.self) { colorID in
          colorID.selectionButton(isSelected: colorID == selection) { selection = colorID }
        }
      }
    }

    public init(_ selection: Binding<ColorID>) { _selection = selection }
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
  @available(iOS 15, macOS 12, *)
  struct SelectColorGrid_Previews: PreviewProvider {
    static var previews: some View {
      Binding.Preview(ColorID.darkBlue) { binding in
        ColorID.SelectionGrid(binding)
          .padding()
          .frame(maxWidth: .infinity, maxHeight: .infinity)
      }
    }
  }
#endif
