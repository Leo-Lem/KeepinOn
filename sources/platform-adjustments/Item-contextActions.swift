//	Created by Leopold Lemmermann on 29.11.22.

import AwardsController
import Errors
import LeosMisc
import SwiftUI

extension View {
  func itemContextActions(_ item: Item, isEditing: Binding<Bool>) -> some View {
    modifier(ItemContextActions(item, isEditing: isEditing))
  }
}

struct ItemContextActions: ViewModifier {
  @Binding var isEditing: Bool
  let item: Item

  @EnvironmentObject private var projectsController: ProjectsController
  @EnvironmentObject private var communityController: CommunityController
  @EnvironmentObject private var awardsController: AwardsController

  init(_ item: Item, isEditing: Binding<Bool>) {
    self.item = item
    _isEditing = isEditing
  }

  func body(content: Content) -> some View {
    content
    #if os(iOS)
    .swipeActions(edge: .leading, content: toggleButton)
    .swipeActions(edge: .trailing) {
      deleteButton()
      editButton()
    }
    #elseif os(macOS)
    .contextMenu {
      toggleButton()
      editButton()
      deleteButton()
    }
    #endif
  }

  func toggleButton() -> some View {
    AsyncButton(indicatorStyle: .replace, taskPriority: .userInitiated) {
      await printError {
        if !item.isDone { try await awardsController.completedItem() }
        try await projectsController.databaseService.modify(Item.self, with: item.id) { mutable in
          mutable.isDone.toggle()
        }
      }
    } label: {
      item.isDone ?
        Label("UNCOMPLETE_ITEM", systemImage: "checkmark.circle.badge.xmark") :
        Label("COMPLETE_ITEM", systemImage: "checkmark.circle")
    }
    .tint(.green)
    .accessibilityIdentifier("toggle-item")
  }

  func editButton() -> some View {
    Button { isEditing = true } label: {
      Label("EDIT", systemImage: "square.and.pencil")
    }
    .tint(.yellow)
    .accessibilityIdentifier("edit-item")
  }

  func deleteButton() -> some View {
    AsyncButton(indicatorStyle: .replace, taskPriority: .userInitiated) {
      await printError {
        await printError {
          try await communityController.databaseService.delete(SharedItem.self, with: item.id)
        }
        
        try await projectsController.databaseService.delete(Item.self, with: item.id)
      }
    } label: {
      Label("DELETE", systemImage: "trash")
    }
    .tint(.red)
    .accessibilityIdentifier("delete-item")
  }
}
