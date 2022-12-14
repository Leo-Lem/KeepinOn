// Created by Leopold Lemmermann on 15.12.22.

struct Friendship: Hashable, Codable {
  let sender: User.ID, receiver: User.ID
  var accepted: Bool
  
  init(_ sender: User.ID, _ receiver: User.ID, accepted: Bool = false) {
    self.sender = sender
    self.receiver = receiver
    self.accepted = accepted
  }
}

extension Friendship: Identifiable {
  var id: ID { ID(sender, receiver) }
  
  struct ID: Hashable {
    let (initiator, receiver): (User.ID, User.ID)
    init(_ initiator: User.ID, _ receiver: User.ID) { (self.initiator, self.receiver) = (initiator, receiver) }
    func concerns(_ user: User.ID?) -> Bool { initiator == user || receiver == user }
  }
}

extension Friendship.ID: LosslessStringConvertible {
  var description: String { "\(initiator)->\(receiver)" }
  
  init?(_ description: String) {
    let split = description.split(separator: "->")
    guard let initiator = split.first, let receiver = split.dropFirst().first else { return nil }
    self.init(User.ID(initiator), User.ID(receiver))
  }
}
