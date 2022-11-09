//	Created by Leopold Lemmermann on 29.10.22.

import Foundation

extension AppView {
  final class ViewModel: KeepinOn.ViewModel {
    override init(appState: AppState) {
      super.init(appState: appState)

      tasks.add(
        routingService.didRouteTo.getTask { [weak self] change in
          if
            case let .banner(banner) = change,
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
    guard let stringID = activity.userInfo?[CSService.activityID] as? String else { return }

    printError {
      if
        let item: Item = try privDBService.fetch(with: stringID),
        let project = item.fetchProject(privDBService)
      {
        routingService.route(
          to: Sheet.item(item, projectWithItems: project.attachItems(privDBService))
        )
      } else if let project: Project = try privDBService.fetch(with: stringID) {
        routingService.route(
          to: Sheet.project(project.attachItems(privDBService))
        )
      }
    }
  }
}
