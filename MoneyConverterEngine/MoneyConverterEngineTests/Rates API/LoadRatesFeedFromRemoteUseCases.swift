//
//  LoadRatesFeedFromRemoteUseCases.swift
//  MoneyConverterEngineTests
//
//  Created by Mikayil on 14/08/2020.
//  Copyright © 2020 Mikayil. All rights reserved.
//

import XCTest

class HTTPClientSpy: HTTPClient {
    
    private struct Task: HTTPClientTask {
        let callback: () -> Void
        func cancel() { callback() }
    }
    
    private var messages = [(url: URL, completion: (HTTPClient.Result) -> Void)]()
    private(set) var cancelledURLs = [URL]()
    
    var requestedURLs: [URL] {
        return messages.map { $0.url }
    }
    
    func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
        messages.append((url, completion))
        return Task { [weak self] in
            self?.cancelledURLs.append(url)
        }
    }
    
    func complete(with error: Error, at index: Int = 0) {
        messages[index].completion(.failure(error))
    }
    
}

protocol RatesFeedLoader {
    typealias Result = Swift.Result<[FeedRate], Error>
    
    func load(completion: @escaping (Result) -> Void)
}

struct FeedRate: Equatable {
    let code: String
    let name: String
    let rate: Double
    let date: String
    let inverseRate: Double
    
    init(code: String, name: String, rate: Double, date: String, inverseRate: Double) {
        self.code = code
        self.name = name
        self.rate = rate
        self.date = date
        self.inverseRate = inverseRate
    }
}

protocol HTTPClientTask {
    func cancel()
}

protocol HTTPClient {
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>
    
    @discardableResult
    func get(from url: URL, completion: @escaping (Result) -> Void) -> HTTPClientTask
}

class RemoteRatesFeedLoader: RatesFeedLoader {
   
    private let url: URL
    private let client: HTTPClient
    
    enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    typealias Result = RatesFeedLoader.Result
    
    func load(completion: @escaping (Result) -> Void) {
        client.get(from: url) { (result) in
            switch result {
            case let .success(data, response):
                completion(RemoteRatesFeedLoader.map(data, from: response))
                
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }
    
    private static func map(_ data: Data, from response: HTTPURLResponse) -> Result {
        do {
            let items = try FeedRatesMapper.map(data, from: response)
            return .success(items.toModels())
        } catch {
            return .failure(error)
        }
    }
}

private extension Array where Element == RemoteFeedRate {
    func toModels() -> [FeedRate] {
        return map { FeedRate(code: $0.code, name: $0.name, rate: $0.rate, date: $0.date, inverseRate: $0.inverseRate) }
    }
}

struct RemoteFeedRate: Decodable {
    let code: String
    let alphaCode: String
    let numericCode: String
    let name: String
    let rate: Double
    let date: String
    let inverseRate: Double
}


final class FeedRatesMapper {
    
    static func map(_ data: Data, from response: HTTPURLResponse) throws -> [RemoteFeedRate] {
        guard response.isOK, let rates = try? JSONDecoder().decode([RemoteFeedRate].self, from: data) else {
            throw RemoteRatesFeedLoader.Error.invalidData
        }

        return rates
    }
}

extension HTTPURLResponse {
    private static var OK_200: Int { return 200 }

    var isOK: Bool {
        return statusCode == HTTPURLResponse.OK_200
    }
}

class LoadRatesFeedFromRemoteUseCases: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL() {
        let (_, client) = makeSUT()
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_load_requestsDataFromURL() {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)
        
        sut.load { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_loadTwice_requestsDataFromURLTwice() {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)
        
        sut.load { _ in }
        sut.load { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    func test_load_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWith: failure(.connectivity), when: {
            let clientError = NSError(domain: "Test", code: 0)
            client.complete(with: clientError)
        })
    }
    
    // MARK: - Helpers
    
    private func makeSUT(url: URL = URL(string: "https://a-url.com")!, file: StaticString = #file, line: UInt = #line) -> (sut: RemoteRatesFeedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteRatesFeedLoader(url: url, client: client)
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(client, file: file, line: line)
        return (sut, client)
    }
    
    private func failure(_ error: RemoteRatesFeedLoader.Error) -> RemoteRatesFeedLoader.Result {
        return .failure(error)
    }
    
    private func expect(_ sut: RemoteRatesFeedLoader, toCompleteWith expectedResult: RemoteRatesFeedLoader.Result, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for load completion")
        
        sut.load { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedItems), .success(expectedItems)):
                XCTAssertEqual(receivedItems, expectedItems, file: file, line: line)
                
            case let (.failure(receivedError as RemoteRatesFeedLoader.Error), .failure(expectedError as RemoteRatesFeedLoader.Error)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)
                
            default:
                XCTFail("Expected result \(expectedResult) got \(receivedResult) instead", file: file, line: line)
            }
            
            exp.fulfill()
        }
        
        action()
        
        wait(for: [exp], timeout: 1.0)
    }
    
}
