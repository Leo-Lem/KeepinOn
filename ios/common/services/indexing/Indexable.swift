//	Created by Leopold Lemmermann on 20.10.22.

import Foundation

protocol Indexable {
  var id: UUID { get }
  var domainID: UUID? { get }
  var title: String { get }
  var details: String { get }
}

extension Project: Indexable {
  var domainID: UUID? { nil }
}

extension Item: Indexable {
  var domainID: UUID? { project?.id }
}
