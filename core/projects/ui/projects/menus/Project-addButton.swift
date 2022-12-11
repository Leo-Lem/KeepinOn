//	Created by Leopold Lemmermann on 07.12.22.

import CoreDataService
import Errors
import LeosMisc
import SwiftUI

extension Project {
  struct AddButton<Label: View>: View {
    let label: () -> Label

    var body: some View {
      AsyncButton(indicatorStyle: .replace, taskPriority: .userInitiated, action: {
        await printError { () -> Void in
          guard mainState.hasFullVersion || !mainState.projectLimitReached else { return isPurchasing = true }
          try await mainState.privateDBService.insert(Project())
        }
      }, label: label)
        .popover(isPresented: $isPurchasing) { InAppPurchaseView(.fullVersion) }
    }

    @State var isPurchasing = false
    @EnvironmentObject private var mainState: MainState

    init(@ViewBuilder label: @escaping () -> Label) { self.label = label }
  }
}
