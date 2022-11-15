//  Created by Leopold Lemmermann on 09.11.22.

import RemoteDatabaseService

typealias RemoteConvertible = RemoteModelConvertible
typealias RemoteDBService = RemoteDatabaseService
typealias RemoteDBChange = RemoteDatabaseChange

#if DEBUG
typealias MockRemoteDBService = MockRemoteDatabaseService
#endif
