//	Created by Leopold Lemmermann on 19.10.22.

import Colors

public struct Award: Hashable, Codable {
  public let name: String,
             description: String,
             colorID: ColorID,
             criterion: Criterion,
             value: Int,
             image: String
  
  public init(name: String, description: String, colorID: ColorID, criterion: Criterion, value: Int, image: String) {
    self.name = name
    self.description = description
    self.colorID = colorID
    self.criterion = criterion
    self.value = value
    self.image = image
  }
}

extension Award: Identifiable {
  public var id: String { name }
}
