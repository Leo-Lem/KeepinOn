//	Created by Leopold Lemmermann on 27.11.22.

import SwiftUI

extension Comment {
  func a11y(posterLabel: String?) -> Text {
    if let posterLabel = posterLabel {
      return Text("A11Y_COMMENT_VALUE \(posterLabel) \(content)")
    } else {
      return Text(content)
    }
  }
}
