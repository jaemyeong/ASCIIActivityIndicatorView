import XCTest

@testable import ASCIIActivityIndicatorView

public final class ASCIIActivityIndicatorViewTests: XCTestCase {
    
    private var view: ASCIIActivityIndicatorView?
    
    public override func setUp() {
        super.setUp()
        
        self.view = ASCIIActivityIndicatorView()
    }
    
    public override func tearDown() {
        super.tearDown()
        
        self.view = nil
    }
    
    func testStartAnimating() throws {
        let view = try XCTUnwrap(self.view)
        view.startAnimating()
        XCTAssertTrue(view.isAnimating)
    }
    
    func testStopAnimating() throws {
        let view = try XCTUnwrap(self.view)
        view.stopAnimating()
        XCTAssertFalse(view.isAnimating)
    }
    
    func testIsAnimating() throws {
        let view = try XCTUnwrap(self.view)
        XCTAssertFalse(view.isAnimating)
    }
    
    func testHidesWhenStopped() throws {
        let view = try XCTUnwrap(self.view)
        XCTAssertTrue(view.isHidden)
        
        view.startAnimating()
        XCTAssertFalse(view.isHidden)
    }
}
