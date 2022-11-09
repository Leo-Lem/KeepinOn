//	Created by Leopold Lemmermann on 09.11.22.

import PrivateDatabaseService

typealias PrivConvertible = PrivateModelConvertible
typealias PrivDBService = PrivateDatabaseService
typealias PrivDBChange = PrivateDatabaseChange

#if DEBUG
typealias MockPrivDBService = MockPrivateDatabaseService
#endif
