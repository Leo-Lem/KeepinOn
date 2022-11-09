import SwiftUI

struct AppView: View {
  @EnvironmentObject var appState: AppState

  var body: some View {
    Group {
      TabView(selection: $vm.page) {
        ForEach(Page.all, id: \.self) { tab in
          NavigationStack {
            tab.getView(appState: appState)
          }
          .tag(tab)
          .tabItem { Label(tab.label, systemImage: tab.icon) }
        }
      }
      // routing to views when the user clicks on element from spotlight search
      .onContinueUserActivity(CSService.activityType) { vm.routeToSpotlightModel($0) }
      .sheet($vm.sheet, appState: vm.appState)
      .alert($vm.alert, routingService: vm.routingService)
      .banner($vm.banner, routingService: vm.routingService)
    }
    .font(.default())
  }

  @StateObject private var vm: ViewModel

  init(appState: AppState) {
    _vm = StateObject(wrappedValue: ViewModel(appState: appState))
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
struct AppView_Previews: PreviewProvider {
  static var previews: some View {
    AppView(appState: .example)
      .previewDisplayName("Loading")
      .configureForPreviews()
  }
}
#endif
