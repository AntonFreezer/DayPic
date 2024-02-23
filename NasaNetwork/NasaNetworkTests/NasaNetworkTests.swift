//
//  NasaNetworkTests.swift
//  NasaNetworkTests
//
//  Created by Anton Kholodkov on 22.02.2024.
//

import XCTest
@testable import NasaNetwork

final class NasaNetworkTests: XCTestCase {
    
    var sut: DefaultNasaNetworkClient!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = DefaultNasaNetworkClient(
            baseURL: "https://api.nasa.gov")
    }
    
    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    /// Test to verify the retrieval of the picture of the day from NASA APOD API.
    func testPictureOfTheDayRequest() {
        
        // Determine the current date and timezone offset based on Daylight Saving Time periods for NASA APOD API
        // FYI - https://github.com/nasa/apod-api/issues/26
        let timeZone = TimeZone(identifier: "EST")!
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = timeZone
        
        let expectation = expectation(description: "APOD response")
        Task {
            let result = await sut.sendRequest(request: NasaAPODRequest())
            expectation.fulfill()
            
            guard let value = try? result.get() else {
                XCTAssert(false)
                return
            }
            
            let easternAmericaCurrentDateString = formatter.string(from: Date.now)
            XCTAssertEqual(easternAmericaCurrentDateString, value.date)
        }
        wait(for: [expectation], timeout: 10)
    }
    
    /// Test to verify the retrieval of the picture from NASA APOD API with date query provided.
    func testPictureOfTheDayRequestWithDate() {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = .autoupdatingCurrent
        let threeDaysAgo = Calendar.current.date(byAdding: .day, value: -3, to: Date.now)
        let threeDaysAgoDate = formatter.string(from: threeDaysAgo!)
        
        let expectation = expectation(description: "APOD with date response")
        Task {
            let result = await sut.sendRequest(
                request: NasaAPODRequest(
                    date: threeDaysAgoDate
                )
            )
            expectation.fulfill()
            
            guard let value = try? result.get() else {
                XCTAssert(false)
                return
            }
            
            XCTAssertEqual(threeDaysAgoDate, value.date)
        }
        wait(for: [expectation], timeout: 10)
    }
}
