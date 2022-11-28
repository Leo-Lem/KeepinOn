//	Created by Leopold Lemmermann on 19.10.22.

import SwiftUI
import AwardsService

extension Award {
  var color: Color { (ColorID(rawValue: colorID) ?? .darkBlue).color }
}
