//	Created by Leopold Lemmermann on 29.10.22.

import Foundation

extension AppView {
  final class ViewModel: KeepinOn.ViewModel {
    override init(appState: AppState) {
      super.init(appState: appState)

      tasks.add(
        routingService.didChange.getTask { [weak self] change in
          if
            case let .routedTo(route) = change,
            case let .banner(banner) = route,
            case .awardEarned = banner
          {
            self?.hapticsService?.play()
          }
          self?.update()
        },
        awardService.didChange.getTask { [weak self] change in
          if case let .unlocked(award) = change {
            self?.routingService.route(to: Banner.awardEarned(award))
          }
        }
      )
    }
  }
}

extension AppView.ViewModel {
  var page: Page {
    get { routingService.page }
    set { routingService.route(to: newValue) }
  }

  var sheet: Sheet? {
    get { routingService.sheet }
    set { routingService.route(to: newValue) }
  }

  var alert: Alert? {
    get { routingService.alert }
    set { routingService.route(to: newValue) }
  }

  var banner: Banner? {
    get { routingService.banner }
    set { routingService.route(to: newValue) }
  }

  func routeToSpotlightModel(_ activity: NSUserActivity) {
    if
      let string = activity.userInfo?[CSService.activityID] as? String,
      let id = UUID(uuidString: string)
    {
      do {
        if let item: Item = try privateDatabaseService.fetch(with: id) {
          routingService.route(to: Sheet.item(item))
        } else if let project: Project = try privateDatabaseService.fetch(with: id) {
          routingService.route(to: Sheet.project(project))
        }
      } catch { print(error.localizedDescription) }
    }
  }
}
