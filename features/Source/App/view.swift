// Created by Leopold Lemmermann on 19.02.25.

import ComposableArchitecture
import SwiftUI

public struct KeepinOnView: View {
  @Bindable var store: StoreOf<KeepinOn>

  public  var body: some View {
    Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
  }

  public init(_ store: StoreOf<KeepinOn> = Store(initialState: KeepinOn.State(), reducer: KeepinOn.init)) {
    self.store = store
  }
}

#Preview {
  KeepinOnView()
}
