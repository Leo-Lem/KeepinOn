//	Created by Leopold Lemmermann on 21.10.22.

import SwiftUI

extension Item {
  var label: String {
    String(localized: .init(title ??? "ITEM_DEFAULTNAME"))
  }

  var detailsLabel: String {
    String(localized: .init(details ??? "ITEM_DETAILS_PLACEHOLDER"))
  }

  struct Icon {
    let name: String,
        a11y: LocalizedStringKey
  }

  var color: Color {
    project?.color ?? ColorID.darkBlue.color
  }

  var icon: String {
    if isDone {
      return "checkmark.circle"
    } else if priority == .high {
      return "exclamationmark.triangle"
    } else {
      return "circle"
    }
  }

  var a11y: LocalizedStringKey {
    if isDone {
      return "A11Y_COMPLETED \(label)"
    } else if priority == .high {
      return "A11Y_PRIORITY \(label)"
    } else {
      return "\(label)"
    }
  }
}
