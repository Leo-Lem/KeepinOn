//	Created by Leopold Lemmermann on 28.11.22.

#if os(iOS)
  @available(iOS 15, macOS 12, *)
  extension AwardDetailPresentation {
    func body(content: Content) -> some View {
      content
        .alert(
          "\(award.name) (\(Text(isUnlocked ? "AWARD_UNLOCKED" : "AWARD_LOCKED", bundle: .module)))",
          isPresented: $isPresented,
          presenting: award
        ) { award in
          if award.criterion == .unlock && !isUnlocked {
            Button { isPurchasing = true } label: {
              Label(String(localized: "UNLOCK_FULL_VERSION", bundle: .module), systemImage: "cart")
            }

            Button("OK") {}
          }
        } message: { award in
          Text("\(award.description)")
        }
    }
  }
#endif
