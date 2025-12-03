//
//  ARCameraUITests.swift
//  GlyptisTests
//
//  Created by Vicenzo Másera on 02/12/25.
//

import XCTest

final class ARCameraViewUITests: XCTestCase {
    
    func testCoachingOverlay() {
        let app = XCUIApplication()
        app.launch()
        
        let arView = app.otherElements["arViewContainer"]
        XCTAssertTrue(arView.exists)
        
        let coachingOverlay = arView.otherElements["arCoachingOverlay"]
        XCTAssertTrue(coachingOverlay.exists)
    }
}
