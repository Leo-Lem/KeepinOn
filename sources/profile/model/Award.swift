//	Created by Leopold Lemmermann on 19.10.22.

import Colors

struct Award: Identifiable, Hashable, Codable {
  var id: String { name }
  
  let name: String,
      description: String,
      colorID: ColorID,
      criterion: Criterion,
      value: Int,
      image: String
}
