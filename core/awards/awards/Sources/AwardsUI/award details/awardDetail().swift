//	Created by Leopold Lemmermann on 28.11.22.

@available(iOS 15, macOS 12, *)
extension View {
  func presentAwardDetails(
    _ award: Award,
    isUnlocked: Bool,
    isPresented: Binding<Bool>,
    isPurchasing: Binding<Bool>
  ) -> some View {
    modifier(AwardDetailPresentation(
      isPresented: isPresented,
      isPurchasing: isPurchasing,
      award: award,
      isUnlocked: isUnlocked
    ))
  }
}

@available(iOS 15, macOS 12, *)
struct AwardDetailPresentation: ViewModifier {
  @Binding var isPresented: Bool
  @Binding var isPurchasing: Bool
  let award: Award, isUnlocked: Bool
}
