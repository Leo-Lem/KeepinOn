//	Created by Leopold Lemmermann on 30.10.22.

import Errors
import Previews
import SwiftUI

extension Item {
  func detailView() -> some View { DetailView(self) }

  struct DetailView: View {
    let item: Item

    var body: some View {
      VStack {
        HStack {
          item.priority.icon
            .font(.default(.headline))
            .bold()

          Text(item.label)
            .font(.default(.largeTitle))
            .fontWeight(.heavy)

          Image(systemName: item.isDone ? "checkmark.circle" : "circle")
            .font(.default(.title1))
            .fontWeight(.bold)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .foregroundColor(project?.color)

        Text("\"\(item.detailsLabel)\"")
          .font(.default(.title2))
          .fontWeight(.medium)

        project?.cardView()
          .padding()

        Spacer()

        Text("created on \(item.timestamp.formatted())")
          .padding()
          .font(.default(.subheadline))
      }
      .presentationDetents([.medium])
    }

    @EnvironmentObject private var mainState: MainState

    init(_ item: Item) { self.item = item }

    private var project: Project? {
      printError { try mainState.localDBService.fetch(with: item.project) }
    }
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
  struct ItemDetails_Previews: PreviewProvider {
    static var previews: some View {
      Item.DetailView(.example)
        .previewDisplayName("Bare")

      Item.example.detailView()
        .previewInSheet()
        .previewDisplayName("Sheet")
    }
  }
#endif