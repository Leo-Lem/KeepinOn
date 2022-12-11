//	Created by Leopold Lemmermann on 23.11.22.

import DatabaseService
import SwiftUI

enum Alert: Equatable {
  case remoteDBError(DatabaseError)
  case deleteProject(Project)
  case noiCloud
}

extension View {
  @ViewBuilder func alert(_ presented: Binding<Alert?>, mainState: MainState) -> some View {
    switch presented.wrappedValue {
    case let .remoteDBError(display):
      alert(isPresented: Binding(item: presented), error: display) {}
      
    case let .deleteProject(project):
      alert("DELETE_PROJECT_ALERT_TITLE", isPresented: Binding(item: presented)) {
        Button("DELETE", role: .destructive) {
          Task(priority: .userInitiated) { await mainState.deleteProject(project) }
        }
      } message: {
        Text("DELETE_PROJECT_ALERT_MESSAGE")
      }
      
    case .noiCloud:
      alert("CANT_CONNECT_TO_ICLOUD_TITLE", isPresented: Binding(item: presented)) {} message: {
        Text("CANT_CONNECT_TO_ICLOUD_MESSAGE")
      }
      
    default: self
    }
  }
}

extension DatabaseError: Equatable {
  public static func == (lhs: DatabaseError, rhs: DatabaseError) -> Bool {
    switch (rhs, lhs) {
    case let (.doesNotExist(type1, id1), .doesNotExist(type2, id2)):
      return type1 == type2 && id1.description == id2.description
    case (.databaseIsReadOnly, .databaseIsReadOnly), (.databaseIsUnavailable, .databaseIsUnavailable):
      return true
    default:
      return false
    }
  }
}
