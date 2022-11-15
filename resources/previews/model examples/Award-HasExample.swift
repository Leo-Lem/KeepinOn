//	Created by Leopold Lemmermann on 19.10.22.

extension Award: HasExample {
  static var example: Award {
    Award(
      name: .random(in: 5 ..< 15, using: .letters),
      description: .random(in: 10 ..< 30, using: .letters.union(.whitespacesAndNewlines)) + ".",
      colorID: .allCases.randomElement() ?? .gold,
      criterion: [Criterion.chat, .complete, .items, .unlock].randomElement() ?? .items,
      value: .random(in: 0..<50),
      image: "figure.walk"
    )
  }
}
