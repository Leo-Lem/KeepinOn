// Created by Leopold Lemmermann on 13.12.22.

extension KeepinOnUITests {
  func testAuthentication() {
    #if targetEnvironment(simulator)
    login(id: "User-1", pin: "1234")
    logout()
    #else
    // register
    login(id: "User-2", pin: "4321", register: true)
    
    // change pin
    let newPIN = "1234"
    changePIN(to: newPIN)
    logout()
    login(id: "User-2", pin: newPIN)
    
    // delete account
    openAccountMenu()
    app.buttons["account-delete"].tap()
    debugPrint(app.alerts.firstMatch.buttons["confirm-account-delete"])
    app.alerts.firstMatch.buttons["confirm-account-delete"].tap()
    
    // verify delete
    openAccountMenu()
    XCTAssertTrue(app.buttons["account-logout"].exists, "Still logged in.")
    #endif
  }
  
  func openAccountMenu() {
    app.buttons["account-menu"].tap()
  }
  
  func login(id: String, pin: String, register: Bool = false) {
    openAccountMenu()
    
    let idField = app.textFields.firstMatch
    idField.tap()
    idField.typeText("\(id)\n")
    
    if register {
      app.alerts.firstMatch.buttons.firstMatch.tap() // confirm registering
    }
    
    let pinField = app.secureTextFields.firstMatch
    pinField.tap()
    pinField.typeText("\(pin)\n")
  }
  
  func changePIN(to newPIN: String) {
    openAccountMenu()
    app.buttons["account-change-pin"].tap()
    
    let newPINField = app.secureTextFields.firstMatch
    newPINField.tap()
    newPINField.typeText("\(newPIN)\n")
  }
  
  func logout() {
    openAccountMenu()
    app.buttons["account-logout"].tap()
  }
}
