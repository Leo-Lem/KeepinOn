//	Created by Leopold Lemmermann on 20.10.22.

import CoreSpotlight

extension Indexable {
  var csAttributes: CSSearchableItemAttributeSet {
    let attributes = CSSearchableItemAttributeSet(contentType: .text)
    attributes.title = title
    attributes.contentDescription = details
    return attributes
  }

  var csSearchableItem: CSSearchableItem {
    CSSearchableItem(
      uniqueIdentifier: id.uuidString,
      domainIdentifier: domainID?.uuidString,
      attributeSet: csAttributes
    )
  }
}
