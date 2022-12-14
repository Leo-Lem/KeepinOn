// Created by Leopold Lemmermann on 14.12.22.

extension User {
  enum AvatarID: Hashable, Codable {
    case person
    case thumbsup
    case thumbsdown
    case family
    case distance
    case handball
    case falling
    case speed
    case soccer
    case swim
    case hiking
    case waving
    case sun
    case moon
    case cloud
    case snow
    case tornado
    case hurricane
    case rabbit
    case turtle
    case bird
    case ant
    case fish
    case dog
    case leaf
    case tree
    case atom
    case flower
    case fossil
    case smiley
    case banknote
    case brain
    case hourglass
    case bed
    case compass
    case other(String)
  }
}

extension User.AvatarID: CaseIterable {
  static let allCases: [Self] = [
    .person, .thumbsup, .thumbsdown, .family, .distance, .handball, .falling,
    .speed, .soccer, .swim, .hiking, .waving, .sun, .moon, .cloud, .snow, .tornado,
    .hurricane, .rabbit, .turtle, .bird, .ant, .fish, .dog, .leaf, .tree, .atom,
    .flower, .fossil, .smiley, .banknote, .brain, .hourglass, .bed, .compass
  ]
}

extension User.AvatarID {
  var systemName: String {
    switch self {
    case .person: return "person"
    case .thumbsup: return "hand.thumbsup"
    case .thumbsdown: return "hand.thumbsdown"
    case .family: return "figure.2.and.child.holdinghands"
    case .distance: return "figure.stand.line.dotted.figure.stand"
    case .handball: return "figure.handball"
    case .falling: return "figure.fall"
    case .speed: return "figure.walk.motion"
    case .soccer: return "figure.australian.football"
    case .swim: return "figure.water.fitness"
    case .hiking: return "figure.hiking"
    case .waving: return "figure.wave"
    case .sun: return "sun.and.horizon"
    case .moon: return "moon.haze"
    case .cloud: return "cloud"
    case .snow: return "snowflake"
    case .tornado: return "tornado"
    case .hurricane: return "tropicalstorm"
    case .rabbit: return "hare"
    case .turtle: return "tortoise"
    case .bird: return "bird"
    case .ant: return "ant"
    case .fish: return "fish"
    case .dog: return "pawprint"
    case .leaf: return "leaf"
    case .tree: return "tree"
    case .atom: return "atom"
    case .flower: return "camera.macro"
    case .fossil: return "fossil.shell"
    case .smiley: return "smiley"
    case .banknote: return "banknote"
    case .brain: return "brain.head.profile"
    case .hourglass: return "hourglass"
    case .bed: return "bed.double"
    case .compass: return "compass.drawing"
    case let .other(name): return name
    }
  }
  
  // swiftlint:disable:next cyclomatic_complexity
  init?(from systemName: String) {
    switch systemName {
    case "person": self = .person
    case "hand.thumbsup": self = .thumbsup
    case "hand.thumbsdown": self = .thumbsdown
    case "figure.2.and.child.holdinghands": self = .family
    case "figure.stand.line.dotted.figure.stand": self = .distance
    case "figure.handball": self = .handball
    case "figure.fall": self = .falling
    case "figure.walk.motion": self = .speed
    case "figure.australian.football": self = .soccer
    case "figure.water.fitness": self = .swim
    case "figure.hiking": self = .hiking
    case "figure.wave": self = .waving
    case "sun.and.horizon": self = .sun
    case "moon.haze": self = .moon
    case "cloud": self = .cloud
    case "snowflake": self = .snow
    case "tornado": self = .tornado
    case "tropicalstorm": self = .hurricane
    case "hare": self = .rabbit
    case "tortoise": self = .turtle
    case "bird": self = .bird
    case "ant": self = .ant
    case "fish": self = .fish
    case "pawprint": self = .dog
    case "leaf": self = .leaf
    case "tree": self = .tree
    case "atom": self = .atom
    case "camera.macro": self = .flower
    case "fossil.shell": self = .fossil
    case "smiley": self = .smiley
    case "banknote": self = .banknote
    case "brain.head.profile": self = .brain
    case "hourglass": self = .hourglass
    case "bed.double": self = .bed
    case "compass.drawing": self = .compass
    default: self = .other(systemName)
    }
  }
}

#if canImport(UIKit)
import UIKit

extension User.AvatarID {
  static func checkSymbolExists(_ systemName: String) -> Bool { UIImage(systemName: systemName) != nil }
}

#elseif canImport(AppKit)
import AppKit

extension User.AvatarID {
  static func checkSymbolExists(_ systemName: String) -> Bool {
    NSImage(systemSymbolName: systemName, accessibilityDescription: nil) != nil
  }
}
#endif
