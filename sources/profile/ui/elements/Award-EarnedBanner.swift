//	Created by Leopold Lemmermann on 29.11.22.

import SwiftUI

extension Award {
  func earnedBanner() -> some View { EarnedBanner(self) }
  
  struct EarnedBanner: View {
    let award: Award
    
    var body: some View {
      HStack {
        Image(systemName: award.image)
          .imageScale(.large)
        
        Spacer()
        
        VStack {
          Text("AWARD_WAS_UNLOCKED \(award.name)").bold()
          Text(award.description)
        }
        
        Spacer()
      }
      .accessibilityIdentifier("award-earned-banner")
    }
    
    init(_ award: Award) { self.award = award }
  }
}

// MARK: - (PREVIEWS)

struct EarnedBanner_Previews: PreviewProvider {
  static var previews: some View {
    Award.EarnedBanner(.example)
  }
}
