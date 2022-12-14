// Created by Leopold Lemmermann on 17.12.22.

import CoreDataService
import CloudKitService
import Errors
import LeosMisc
import SwiftUI

extension MainView {
  func testDataMenu() -> some ToolbarContent {
    ToolbarItem(content: EmptyView.init)
//    ToolbarItemGroup(placement: .secondaryAction) {
//      addPrivateDataButton()
//      addPublicDataButton()
//
//      AsyncButton(indicatorStyle: .replace, taskPriority: .userInitiated) {
//        await printError {
//          try await databaseService.deleteAll(Project.self)
//          try await databaseService.deleteAll(Item.self)
//        }
//      } label: {
//        Label("Delete private data", systemImage: "text.badge.xmark")
//      }
//
//      AsyncButton(indicatorStyle: .replace, taskPriority: .userInitiated) {
//        await printError {
//          try await accountController.databaseService.deleteAll(User.self) // delete will cascade to all other types
//        }
//      } label: {
//        Label("Delete public data", systemImage: "text.badge.xmark")
//      }
//    }
  }
  
//  private func addPrivateDataButton() -> some View {
//    AsyncButton(indicatorStyle: .replace, taskPriority: .userInitiated) {
//      await printError {
//        for project in [Project.example, .example, .example] {
//          try await databaseService.insert(project)
//
//          for itemID in project.items {
//            let example = Item.example
//            let item = Item(
//              id: itemID, title: example.title, details: example.details,
//              isDone: example.isDone, priority: example.priority, project: project.id
//            )
//            try await databaseService.insert(item)
//          }
//        }
//      }
//    } label: { Label("Add private data", systemImage: "text.badge.plus") }
//  }
//
//  private func addPublicDataButton() -> some View {
//    AsyncButton(indicatorStyle: .replace, taskPriority: .userInitiated) {
//      var convertibles = [any DatabaseObjectConvertible]()
//
//      // creating users
//      for user in [User.example, .example] {
//        convertibles.append(user)
//
//        let sharedProject = SharedProject(.example, owner: user.id)
//        convertibles.append(sharedProject)
//
//        // creating items,
//        for itemID in [Item.ID(), Item.ID()] {
//          let sharedItem = SharedItem(
//            id: itemID, title: Item.example.title, details: Item.example.details, isDone: Item.example.isDone,
//            project: sharedProject.id
//          )
//          convertibles.append(sharedItem)
//        }
//
//        // creating comments
//        for _ in 0 ..< 3 {
//          convertibles.append(Comment(content: Comment.example.content, project: sharedProject.id, poster: user.id))
//        }
//      }
//
//      await printError {
//        try await accountController.databaseService.insert(convertibles).collect()
//      }
//    } label: { Label("Add public data", systemImage: "text.badge.plus") }
//  }
}
