import XCTest
import Bow

class TrampolineTest: XCTestCase {
    func testDoesNotCrashStack() {
        XCTAssert(isEven(200000))
    }
    
    func isEven(_ n: Int) -> Bool {
        _isEven(n).run()
    }
    
    func _isEven(_ n: Int) -> Trampoline<Bool> {
        if n == 0 {
            return .done(true)
        } else if n == 1 {
            return .done(false)
        } else {
            return .defer { self._isOdd(n - 1) }
        }
    }
    
    func _isOdd(_ n: Int) -> Trampoline<Bool> {
        if n == 0 {
            return .done(false)
        } else if n == 1 {
            return .done(true)
        } else {
            return .defer { self._isEven(n - 1) }
        }
    }
}
