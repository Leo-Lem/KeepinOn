// Created by Leopold Lemmermann on 20.02.25.

public enum Priority: Int, Comparable, Codable {
  case flexible = 1
  case prioritized
  case urgent

  public static func < (lhs: Self, rhs: Self) -> Bool { lhs.rawValue < rhs.rawValue }
}
