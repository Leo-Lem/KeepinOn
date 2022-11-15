//	Created by Leopold Lemmermann on 27.10.22.

import CoreHaptics

final class CHService: HapticsService {
  private let engine: CHHapticEngine

  init() throws {
    engine = try CHHapticEngine()
  }

  func play() {
    do {
      try engine.start()
      let player = try engine.makePlayer(with: try .taDa())
      try player.start(atTime: 0)
    } catch {
      print(error.localizedDescription)
    }
  }
}

extension CHHapticPattern {
  static func taDa() throws -> CHHapticPattern {
    let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0),
        intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1),
        start = CHHapticParameterCurve.ControlPoint(relativeTime: 0, value: 1),
        end = CHHapticParameterCurve.ControlPoint(relativeTime: 1, value: 0)

    let parameter = CHHapticParameterCurve(
      parameterID: .hapticIntensityControl,
      controlPoints: [start, end],
      relativeTime: 0
    )

    let event1 = CHHapticEvent(
      eventType: .hapticTransient,
      parameters: [intensity, sharpness],
      relativeTime: 0
    )

    // create a continuous haptic event starting immediately and lasting one second
    let event2 = CHHapticEvent(
      eventType: .hapticContinuous,
      parameters: [sharpness, intensity],
      relativeTime: 0.125,
      duration: 1
    )

    return try CHHapticPattern(events: [event1, event2], parameterCurves: [parameter])
  }
}
