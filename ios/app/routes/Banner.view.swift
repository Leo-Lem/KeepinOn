//	Created by Leopold Lemmermann on 06.11.22.

import SwiftUI

extension View {
  func banner(
    _ banner: Binding<Banner?>,
    routingService: any RoutingService
  ) -> some View {
    self.banner(Binding(optional: banner), dismissAfter: .seconds(3)) {
      switch banner.wrappedValue {
      case let .awardEarned(award):
        routingService.route(to: Page.awards)
        routingService.route(to: Alert.award(award, unlocked: true))
      default: break
      }
    } content: {
      switch banner.wrappedValue {
      case let .awardEarned(award):
        Text("You unlocked an award!").bold()
        Text("\(Text(award.id).bold()): \(award.description)")
      default: EmptyView()
      }
    }
    .environment(\.dismiss) {
      routingService.dismiss(.banner())
    }
  }
}
