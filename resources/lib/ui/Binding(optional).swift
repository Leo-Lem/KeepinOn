//	Created by Leopold Lemmermann on 06.11.22.

import SwiftUI

extension Binding where Value == Bool {
  init<T>(optional: Binding<T?>, defaultValue: T? = nil) {
    self.init {
      optional.wrappedValue != nil
    } set: { newValue in
      optional.wrappedValue = newValue ? defaultValue : nil
    }
  }
}
