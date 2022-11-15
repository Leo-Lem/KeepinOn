//	Created by Leopold Lemmermann on 15.11.22.

import KeyValueStorageService
import UserDefaultsStorageService

typealias KVSService = KeyValueStorageService
typealias MockKVSService = MockKeyValueStorageService

class UDService: UserDefaultsStorageService {
  init() {
    super.init(cloudDefaults: .default)
  }
}
