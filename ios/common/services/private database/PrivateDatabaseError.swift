//	Created by Leopold Lemmermann on 31.10.22.

enum PrivateDatabaseError: Error {
  case mappingToPrivateModel(from: PrivateModelConvertible.Type),
       mappingFromPrivateModel(to: PrivateModelConvertible.Type),
       other(Error?)
}
