// Created by Leopold Lemmermann on 09.12.22.

import SwiftUI

extension View {
  func presentDetail<D: View>(
    _ detail: Binding<Detail?>, @ViewBuilder presentDetail: @escaping (Detail?) -> D
  ) -> some View {
    #if os(iOS)
    self.sheet(item: detail, content: presentDetail)
    #elseif os(macOS)
    NavigationSplitView(sidebar: self.create) { presentDetail(detail.wrappedValue) }
    #endif
  }
}
