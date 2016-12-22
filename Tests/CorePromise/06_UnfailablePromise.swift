import XCTest
import PromiseKit


class UnfailablePromiseTests: XCTestCase {
    func testWith_value() {
        let promise = Promise<Int>.with(5)

        XCTAssertEqual("\(promise)", "Promise: SealedState: Fulfilled with value: 5")
    }

    func testWith_error() {
        let ex = expectation(description: "promise rejected")
        enum E: Swift.Error {
            case dummy
        }

        Promise<Int>.with(E.dummy)
                    .catch { err in
            XCTAssertEqual(err as? E, E.dummy)
            ex.fulfill()
        }

        waitForExpectations(timeout: 1)
    }

    func testFirstly() {
        let exFailable = expectation(description: "firstly failable")
        let exUnfailable = expectation(description: "firstly unfailable")

        _ = firstly { () throws -> Promise<Void> in
            return Promise<()>(value: ())
        }.then {
            exFailable.fulfill()
        }

        firstly {
            Promise<Void>.with(())
        }.then {
            exUnfailable.fulfill()
        }

        waitForExpectations(timeout: 1.0)
    }
}

