//
// Copyright © 2020 Stormwright. All rights reserved.
//

import XCTest
import MoneyConverterEngine

extension FailableDeleteRatesFeedStoreSpecs where Self: XCTestCase {
    func assertThatDeleteDeliversErrorOnDeleteError(on sut: RatesFeedStore, file: StaticString = #file, line: UInt = #line) {
        let deletionError = deleteCache(from: sut)
        
        XCTAssertNotNil(deletionError, "Expected cache delete to fail", file: file, line: line)
    }
    
    func assertThatDeleteHasNoSideEffectsOnDeleteError(on sut: RatesFeedStore, file: StaticString = #file, line: UInt = #line) {
        deleteCache(from: sut)
        
        expect(sut, toRetrieve: .success(.none), file: file, line: line)
    }
}
