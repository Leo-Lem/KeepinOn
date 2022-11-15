//	Created by Leopold Lemmermann on 10.11.22.

import SwiftUI

extension ForEach where Content: View {
  @ViewBuilder
  func replaceIfEmpty<Replacement: View>(with replacement: () -> Replacement) -> some View {
    if self.data.isEmpty {
      replacement()
    } else {
      self
    }
  }
  
  func replaceIfEmpty(with description: LocalizedStringKey) -> some View {
    replaceIfEmpty { Text(description) }
  }
  
  @_disfavoredOverload
  func replaceIfEmpty<S: StringProtocol>(with description: S) -> some View {
    replaceIfEmpty { Text(description) }
  }
}
