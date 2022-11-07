//	Created by Leopold Lemmermann on 07.11.22.

import Foundation

func sleep(for duration: Duration) async {
  try? await Task.sleep(for: duration)
}
