//
// Copyright © 2020 Stormwright. All rights reserved.
//

import XCTest
import MoneyConverterEngine

class MoneyConverterEngineAPIEndToEndTests: XCTestCase {

    func test_endToEndTestServerGETFeedResult_matchesFixedTestAccountData() {
        switch getRatesFeedResult() {
        case let .success(ratesFeed)?:
            XCTAssertEqual(ratesFeed.count, 12, "Expected 12 rates in the test account rates feed")
            XCTAssertEqual(ratesFeed[0], expectedRate(at: 0))
            XCTAssertEqual(ratesFeed[1], expectedRate(at: 1))
            XCTAssertEqual(ratesFeed[2], expectedRate(at: 2))
            XCTAssertEqual(ratesFeed[3], expectedRate(at: 3))
            XCTAssertEqual(ratesFeed[4], expectedRate(at: 4))
            XCTAssertEqual(ratesFeed[5], expectedRate(at: 5))
            
        case let .failure(error)?:
            XCTFail("Expected successful feed result, got \(error) instead")
            
        default:
            XCTFail("Expected successful feed result, got no result instead")
        }
    }
    
    func test_endToEndTestServerGETFeedRateDataResult_matchesFixedTestAccountData() {
        switch getRatesFeedResult() {
        case let .success(data)?:
            XCTAssertFalse(data.isEmpty, "Expected non-empty rates data")
            
        case let .failure(error)?:
            XCTFail("Expected successful rates data result, got \(error) instead")
            
        default:
            XCTFail("Expected successful rates data result, got no result instead")
        }
    }
    
    // MARK: - Helpers
    
    private func getRatesFeedResult(file: StaticString = #file, line: UInt = #line) -> RatesFeedLoader.Result? {
        let loader = RemoteRatesFeedLoader(url: feedTestServerURL, client: ephemeralClient())
        trackForMemoryLeaks(loader, file: file, line: line)
        
        let exp = expectation(description: "Wait for load completion")
        
        var receivedResult: RatesFeedLoader.Result?
        loader.load { result in
            receivedResult = result
            exp.fulfill()
        }
        wait(for: [exp], timeout: 5.0)
        
        return receivedResult
    }
    
    private var feedTestServerURL: URL {
        return URL(string: "https://pastebin.com/raw/gg4BAg5z")!
    }
    
    private func ephemeralClient(file: StaticString = #file, line: UInt = #line) -> HTTPClient {
        let client = URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
        trackForMemoryLeaks(client, file: file, line: line)
        return client
    }
    
    private func expectedRate(at index: Int) -> FeedRate {
        return FeedRate(code: code(at: index), name: name(at: index), rate: rate(at: index), date: date(at: index), inverseRate: inverseRate(at: index))
    }
    
    private func code(at index: Int) -> String {
        return [
            "EUR",
            "GBP",
            "CHF",
            "AUD",
            "CAD",
            "JPY"
        ][index]
    }
    
    private func name(at index: Int) -> String {
        return [
            "Euro",
            "British Pound Sterling",
            "Swiss Franc",
            "Australian Dollar",
            "Canadian Dollar",
            "Japanese Yen"
        ][index]
    }
    
    private func rate(at index: Int) -> Double {
        return [
            0.84665715551541,
            0.75783966587706,
            0.90937626612241,
            1.3806249314942,
            1.3132180300058,
            106.09794883061
        ][index]
    }
    
    private func date(at index: Int) -> String {
        return [
            "Fri, 28 Aug 2020 00:00:01 GMT",
            "Fri, 28 Aug 2020 00:00:01 GMT",
            "Fri, 28 Aug 2020 00:00:01 GMT",
            "Fri, 28 Aug 2020 00:00:01 GMT",
            "Fri, 28 Aug 2020 00:00:01 GMT",
            "Fri, 28 Aug 2020 00:00:01 GMT"
        ][index]
    }
    
    private func inverseRate(at index: Int) -> Double {
        return [
            1.1811156304363,
            1.3195403263073,
            1.0996548263394,
            0.72430967831193,
            0.76148817420332,
            0.0094252529009448
        ][index]
    }

}
