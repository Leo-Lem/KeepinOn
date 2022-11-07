//	Created by Leopold Lemmermann on 25.10.22.

import SwiftUI

struct PublishingMenu: ToolbarContent {
  let isPublished: Bool?,
      publish: () -> Void,
      unpublish: () -> Void

  var body: some ToolbarContent {
    ToolbarItemGroup(placement: .navigationBarLeading) {
      if let isPublished = self.isPublished {
        Button(action: publish) {
          isPublished ?
            Label("Update", systemImage: "arrow.clockwise.icloud") :
            Label("Publish", systemImage: "icloud.and.arrow.up")
        }

        if isPublished {
          Button(action: unpublish) {
            Label("Unpublish", systemImage: "xmark.icloud")
          }
        }
      } else {
        ProgressView()
      }
    }
  }
}

// MARK: - (PREVIEWS)

struct PublishingMenu_Previews: PreviewProvider {
  static var previews: some View {
    NavigationStack {
      Text("")
        .toolbar { PublishingMenu(isPublished: false, publish: {}, unpublish: {}) }
    }
    .previewDisplayName("Not Published")

    NavigationStack {
      Text("")
        .toolbar { PublishingMenu(isPublished: true, publish: {}, unpublish: {}) }
    }
    .previewDisplayName("Published")
  }
}
