//	Created by Leopold Lemmermann on 06.11.22.

import AwardsService
import LeosMisc
import SwiftUI

enum Banner: Hashable, Codable {
  case awardEarned(Award)
}

extension View {
  func banner(_ bannerType: Binding<Banner?>) -> some View {
    banner(presenting: bannerType, dismissAfter: .seconds(3)) { bannerType in
      switch bannerType {
      case let .awardEarned(award):
        HStack {
          Image(systemName: award.image)
            .imageScale(.large)

          Spacer()

          VStack {
            Text("UNLOCKED \(award.name)").bold()
            Text(award.description)
          }

          Spacer()
        }
      }
    }
  }
}
