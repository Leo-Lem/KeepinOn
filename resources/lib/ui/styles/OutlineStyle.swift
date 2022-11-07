//	Created by Leopold Lemmermann on 06.11.22.

import SwiftUI

struct OutlineStyle: Style {
  let color: Color,
      cornerRadius: Double,
      stroke: Double

  init(
    color: Color = .accentColor,
    cornerRadius: Double = 10,
    stroke: Double = 4
  ) {
    self.color = color
    self.cornerRadius = cornerRadius
    self.stroke = stroke
  }

  static let none = OutlineStyle(color: .clear, cornerRadius: 0, stroke: 0)

  struct Key: PreferenceKey {
    static var defaultValue = OutlineStyle()
  }
}

extension View {
  func outline(_ style: OutlineStyle) -> some View {
    cornerRadius(style.cornerRadius)
      .overlay(
        style.color,
        in: RoundedRectangle(cornerRadius: style.cornerRadius)
          .stroke(style: .init(lineWidth: style.stroke))
      )
  }
}
