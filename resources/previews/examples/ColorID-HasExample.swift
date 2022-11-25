//	Created by Leopold Lemmermann on 10.11.22.

extension ColorID: HasExample {
  static var example: ColorID { allCases.randomElement() ?? .gray }
}
