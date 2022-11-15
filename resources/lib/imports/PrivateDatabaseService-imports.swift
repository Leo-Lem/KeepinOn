//	Created by Leopold Lemmermann on 09.11.22.

import LocalDatabaseService

typealias LocalConvertible = LocalModelConvertible
typealias LocalDBService = LocalDatabaseService
typealias LocalDBChange = LocalDatabaseChange

#if DEBUG
typealias MockLocalDBService = MockLocalDatabaseService
#endif
