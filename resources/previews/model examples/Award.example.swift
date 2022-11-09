//	Created by Leopold Lemmermann on 19.10.22.

extension Award: HasExample {
  static let example = Award(
    name: "First Steps",
    description: "Add your first item.",
    colorID: .lightBlue,
    criterion: .items,
    value: 1,
    image: "figure.walk"
  )
}
