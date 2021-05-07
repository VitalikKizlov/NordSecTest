//
//  Tests_iOS.swift
//  Tests iOS
//
//  Created by Vitalii Kizlov on 06.05.2021.
//

import XCTest
@testable import NordSecTest

class Tests_iOS: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
    
    func testDownloadWebData() {
        let parameters: [String: String] = ["username": "tesonet", "password": "partyanimal"]
        var components = URLComponents()
        components.scheme = "https"
        components.host = "playground.tesonet.lt"
        components.path = "/v1/tokens"
        components.queryItems = parameters.compactMap { URLQueryItem(name: $0.key, value: $0.value)}
        
        guard let url = components.url else {
            XCTFail("Can't create URL")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let promise = expectation(description: "Status code: 200")
        let dataTask = URLSession.shared.dataTask(with: request) { _, response, error in
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
                return
            } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if statusCode == 200 {
                    promise.fulfill()
                } else {
                    XCTFail("Status code: \(statusCode)")
                }
            }
        }
        dataTask.resume()
        wait(for: [promise], timeout: 5)
    }
}
