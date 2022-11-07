//	Created by Leopold Lemmermann on 31.10.22.

import Combine

protocol ObservableService: AnyObject {
  var didChange: PassthroughSubject<Void, Never> { get }
}
