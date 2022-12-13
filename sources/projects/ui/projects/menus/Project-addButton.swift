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
          guard iapController.fullVersionIsUnlocked || !projectsController.projectsLimitReached else {
            return isPurchasing = true
          }
          
          try await projectsController.databaseService.insert(Project())
        }
      }, label: label)
        .popover(isPresented: $isPurchasing) { InAppPurchaseView(.fullVersion) }
    }

    @State var isPurchasing = false
    
    @EnvironmentObject private var projectsController: ProjectsController
    @EnvironmentObject private var iapController: IAPController

    init(@ViewBuilder label: @escaping () -> Label) { self.label = label }
  }
}
