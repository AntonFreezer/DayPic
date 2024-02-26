//
//  NasaLibraryTests.swift
//  NasaLibraryTests
//
//  Created by Anton Kholodkov on 24.02.2024.
//

import XCTest
@testable import NasaNetwork

final class NasaLibraryTests: XCTestCase {
    
    var sut: NasaNetworkClient!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = DefaultNasaNetworkClient(
            baseURL: "https://images-api.nasa.gov")
    }
    
    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    /// Test to verify the retrieval of the picture by query from the NASA Image and Video Library API.
    func testPicturesPaginatedRequest() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = .autoupdatingCurrent
        
        let expectation = expectation(description: "NASA Library picture by query response")
        Task {
            let result = await sut.sendRequest(request: NasaLibraryPictureRequest(query: "Moon"))
            expectation.fulfill()
            
            guard let value = try? result.get() else {
                XCTAssert(false)
                return
            }
            
            XCTAssertTrue(value.collection.items.count > 0 &&
                          value.collection.items.allSatisfy { $0.data.first?.mediaType == "image"
            })
            
            XCTAssertTrue(value.collection.items.contains { picture in
                picture.data.contains { data in
                    data.description.contains("Moon")
                }
            })
                
            
        }
        wait(for: [expectation], timeout: 10)
    }
    
}
