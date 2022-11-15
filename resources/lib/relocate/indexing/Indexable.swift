//	Created by Leopold Lemmermann on 20.10.22.

import Foundation

protocol Indexable: Identifiable where ID: CustomStringConvertible {
  var title: String { get }
  var details: String { get }
}
