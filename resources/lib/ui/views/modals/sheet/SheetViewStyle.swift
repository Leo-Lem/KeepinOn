//	Created by Leopold Lemmermann on 06.11.22.

import SwiftUI

struct SheetViewStyle: Style {
  let size: Size,
      dismissButtonStyle: DismissButtonStyle

  init(
    size: Size = .full,
    dismissButtonStyle: DismissButtonStyle = .top
  ) {
    self.size = size
    self.dismissButtonStyle = dismissButtonStyle
  }

  enum Size: Equatable {
    case full, half, fixed(Double), fraction(Double), dynamic
  }

  enum DismissButtonStyle: Equatable {
    case hidden, top, bottom
  }

  struct Key: PreferenceKey {
    static var defaultValue = SheetViewStyle()
  }

  static let none = SheetViewStyle(size: .dynamic, dismissButtonStyle: .hidden)
}

extension View {
  func sheetFrame(_ size: SheetViewStyle.Size) -> some View {
    let screenHeight = UIScreen.main.bounds.height
    let height: Double?

    switch size {
    case .full: height = 0.95 * screenHeight
    case .half: height = screenHeight / 2
    case let .fixed(h): height = h
    case let .fraction(fraction): height = fraction * screenHeight
    case .dynamic: height = nil
    }

    return Group {
      if let height = height {
        frame(height: height)
      } else { self }
    }
  }
}
