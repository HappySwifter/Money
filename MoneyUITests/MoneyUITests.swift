//
//  MoneyUITests.swift
//  MoneyUITests
//
//  Created by Artem on 27.02.2024.
//

import XCTest

//Naming Structure: test_UnitOfWork_StateUnderTest_ExpectedBehavior
//Naming Structure: test_[struct]_[ui component]_[expected result]
//Testing Structure: Given, When, Then

final class MoneyUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        XCUIApplication().launch()
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_Dashboard_shouldOpenPaymentView() {
        let app = XCUIApplication()
        app.scrollViews["_ScrollView"].otherElements.buttons["_CategoryView_Button"].images["_IconView_Image"].tap()
        let newExpenseNavigationBar = app.navigationBars["New expense"]
        newExpenseNavigationBar.staticTexts["New expense"].tap()
        newExpenseNavigationBar.buttons["Close"].tap()
    }

    func test_Category_IconAndNameView_NavigationLink_SymbolPickerView_shouldOpen() {
        let app = XCUIApplication()
        let elementsQuery = app.scrollViews.otherElements
        elementsQuery.buttons["_CategoryView_Button"].images["_IconView_Image"].press(forDuration: 1.4);
        elementsQuery.buttons["_NewAccountEmojiAndNameView_NavigationLink"].tap()
        app.navigationBars["Icon"].buttons["Save"].tap()
        app.navigationBars["_TtGC7SwiftUI32NavigationStackHosting"].buttons["Close"].tap()
        
    }
    
    func test_Account_IconAndNameView_NavigationLink_SymbolPickerView_shouldOpen() {
        
        let app = XCUIApplication()
        let elementsQuery = app.scrollViews.otherElements
        elementsQuery.buttons["_AccountView_Button"].images["_IconView_Image"].press(forDuration: 1.4);
        elementsQuery.buttons["_NewAccountEmojiAndNameView_NavigationLink"].tap()
        app.navigationBars["Icon"].buttons["Save"].tap()
        app.navigationBars["_TtGC7SwiftUI32NavigationStackHosting"].buttons["Close"].tap()
    }
    
    func test_Dashboard_shouldOpenAccountsList() {
        let app = XCUIApplication()
        app.buttons["_AllAccountButton"].tap()
        app.collectionViews.buttons["_AccountDetailsViewLink"].tap()
        let backButton = app.navigationBars["_TtGC7SwiftUI32NavigationStackHosting"].buttons["Back"]
        backButton.tap()
        backButton.tap()
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
