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

    /// test without assertion, but they may fail if compiling should fail on warning
    func testLogic() {
        // unfailable + unfailable #1
        Promise<Int>.with(5).then { val in
                    return Promise(value: val + 10)
                }

        // unfailable + unfailable #2
        Promise<Int>.with(5).then { (val: Int) -> Int in
                    return val + 10
                }

        // unfailable + failable #1 -> warning
        _ = Promise<Int>.with(5).then { val throws -> Int in
            return val + 5
        }

        // failable + unfailable -> warning
        _ = Promise<Int>.with(5).then { val throws -> Int in
            return val + 5
        }

        // failable + failable -> warning
        _ = Promise(value: 5).then { val throws -> Int in
            return val + 5
        }
    }
}

