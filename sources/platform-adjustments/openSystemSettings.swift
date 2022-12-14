// Created by Leopold Lemmermann on 08.12.22.

#if canImport(UIKit)
import UIKit
#endif

func openSystemSettings() {
  #if canImport(UIKit)
  URL(string: UIApplication.openNotificationSettingsURLString)
    .flatMap { UIApplication.shared.open($0) }
  #endif
}
