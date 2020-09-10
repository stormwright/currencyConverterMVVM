//
// Copyright © 2020 Stormwright. All rights reserved.
//

import XCTest
import MoneyConverterEngine

extension FailableInsertRatesFeedStoreSpecs where Self: XCTestCase {
    func assertThatInsertDeliversErrorOnInsertError(on sut: RatesFeedStore, file: StaticString = #file, line: UInt = #line) {
        let insertionError = insert((uniqueRatesFeed().local, Date()), to: sut)
        
        XCTAssertNotNil(insertionError, "Expected cache insert to fail with an error", file: file, line: line)
    }
    
    func assertThatInsertHasNoSideEffectsOnInsertError(on sut: RatesFeedStore, file: StaticString = #file, line: UInt = #line) {
        insert((uniqueRatesFeed().local, Date()), to: sut)
        
        expect(sut, toRetrieve: .success(.none), file: file, line: line)
    }
}
