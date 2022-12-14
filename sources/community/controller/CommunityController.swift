// Created by Leopold Lemmermann on 13.12.22.

import Foundation
import CloudKitService

class CommunityController: ObservableObject {
  let databaseService: any DatabaseService
  
  init(databaseService: any DatabaseService) {
    self.databaseService = databaseService
  }
}
