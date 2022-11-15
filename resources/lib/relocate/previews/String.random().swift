//	Created by Leopold Lemmermann on 10.11.22.

import Foundation

extension String {
  static func random(
    in range: Range<Int>,
    using chars: CharacterSet = .alphanumerics
  ) -> String {
    random(count: .random(in: range), using: chars)
  }

  static func random(
    count: Int = .random(in: 3 ..< 10),
    using chars: CharacterSet = .alphanumerics
  ) -> String {
    String((0 ..< count).compactMap { _ in
      while true {
        if
          let char = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 \n.".randomElement(),
          char.unicodeScalars.allSatisfy(chars.contains)
        {
          return char
        }
      }
    })
  }
}
