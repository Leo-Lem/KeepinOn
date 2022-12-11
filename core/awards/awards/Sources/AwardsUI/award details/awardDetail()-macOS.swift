//	Created by Leopold Lemmermann on 28.11.22.

#if os(macOS)
  @available(iOS 15, macOS 12, *)
  extension AwardDetailPresentation {
    func body(content: Content) -> some View {
      content
        .popover(isPresented: $isPresented) {
          VStack {
            Text(isUnlocked ? "AWARD_UNLOCKED \(award.name)" : "AWARD_LOCKED", bundle: .module).bold()
            Text(award.description)

            HStack {
              if award.criterion == .unlock && !isUnlocked {
                Button { isPurchasing = true } label: {
                  Label(String(localized: "UNLOCK_FULL_VERSION", bundle: .module), systemImage: "cart")
                }
              }
            }
          }
          .padding()
        }
    }
  }
#endif
