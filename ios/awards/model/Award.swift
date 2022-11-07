//	Created by Leopold Lemmermann on 19.10.22.

import Foundation

struct Award: Hashable, Codable {
  let name: String,
      description: String,
      colorID: ColorID,
      criterion: Criterion,
      value: Int,
      image: String
}

extension Award: Identifiable {
  var id: String { name }
}
