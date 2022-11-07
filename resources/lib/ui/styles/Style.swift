//	Created by Leopold Lemmermann on 06.11.22.

import SwiftUI

protocol Style: Equatable {
  associatedtype Key: PreferenceKey
  
  static var none: Self { get }
}
