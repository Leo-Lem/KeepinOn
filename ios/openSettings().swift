//	Created by Leopold Lemmermann on 28.11.22.

import UIKit

extension Project.EditingView {
  func openSettings() {
    URL(string: UIApplication.openNotificationSettingsURLString)
      .flatMap {  UIApplication.shared.open($0) }
  }
}
