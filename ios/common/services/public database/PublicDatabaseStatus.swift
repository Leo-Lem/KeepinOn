//	Created by Leopold Lemmermann on 27.10.22.

enum PublicDatabaseStatus {
  case available,
       readOnly,
       unavailable(Error? = nil)
}
