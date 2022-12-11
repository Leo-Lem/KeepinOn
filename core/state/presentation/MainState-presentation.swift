//	Created by Leopold Lemmermann on 04.12.22.

import Concurrency

extension MainState {
  func showPresentation(_ page: Page? = nil, detail: Detail? = nil, banner: Banner? = nil, alert: Alert? = nil) {
    if let page { presentation.page = page }
    if let detail { presentation.detail = detail }
    if let banner { presentation.banner = banner }
    if let alert { presentation.alert = alert }
  }

  func showPresentationAndAwaitDismiss(
    _ page: Page? = nil, detail: Detail? = nil, banner: Banner? = nil, alert: Alert? = nil
  ) async {
    if let page { presentation.page = page }
    if let detail {
      presentation.detail = detail
      while presentation.detail == detail { await sleep(for: .nanoseconds(1000)) }
    }
    if let banner {
      presentation.banner = banner
      while presentation.banner == banner { await sleep(for: .nanoseconds(1000)) }
    }
    if let alert {
      presentation.alert = alert
      while presentation.alert == alert { await sleep(for: .nanoseconds(1000)) }
    }
  }

  func dismissPresentation(detail: Bool = false, banner: Bool = false, alert: Bool = false) {
    if detail { presentation.detail = nil }
    if banner { presentation.banner = nil }
    if alert { presentation.alert = nil }
  }
}
