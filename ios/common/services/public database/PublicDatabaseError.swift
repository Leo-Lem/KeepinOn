//	Created by Leopold Lemmermann on 31.10.22.

enum PublicDatabaseError: Error {
  case userRelevant(reason: UserRelevancyReason),
       mappingToPublicModel(from: PublicModelConvertible.Type),
       mappingFromPublicModel(to: PublicModelConvertible.Type),
       other(Error?)

  enum UserRelevancyReason {
    case notAuthenticated,
         noNetwork,
         rateLimited
  }
}
