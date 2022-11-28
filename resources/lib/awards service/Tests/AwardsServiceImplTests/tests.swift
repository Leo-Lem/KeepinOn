@testable import AwardsServiceImpl
import AwardsServiceTests

class AwardsServiceImplTests: AwardsServiceTests<AwardsServiceImpl> {
  override func setUp() {
    service = AwardsServiceImpl(.mock)
    service.resetProgress()
  }
}
