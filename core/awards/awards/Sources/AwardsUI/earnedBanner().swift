//	Created by Leopold Lemmermann on 29.11.22.

@available(iOS 14, macOS 11, *)
extension Award {
  public func earnedBanner() -> some View { EarnedBanner(self) }
  
  struct EarnedBanner: View {
    let award: Award
    
    var body: some View {
      HStack {
        Image(systemName: award.image)
          .imageScale(.large)
        
        Spacer()
        
        VStack {
          Text("AWARD_UNLOCKED \(award.name)", bundle: .module).bold()
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
@available(iOS 14, macOS 11, *)
struct EarnedBanner_Previews: PreviewProvider {
  static var previews: some View {
    Award.EarnedBanner(.example)
  }
}
