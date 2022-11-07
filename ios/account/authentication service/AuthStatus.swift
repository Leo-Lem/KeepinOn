//	Created by Leopold Lemmermann on 21.10.22.

enum AuthStatus {
  case notAuthenticated,
       authenticated(User)
}
