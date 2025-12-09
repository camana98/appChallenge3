//
//  CanvasViewUITests.swift
//  Glyptis
//
//  Created by Vicenzo Másera on 03/12/25.
//
import XCTest

final class CanvasViewUITests: XCTestCase {
    
    func tapCenter(app: XCUIApplication) {
        let coord = app.windows.firstMatch.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5))
        coord.tap()
    }
    
    func testCloseCanvas() {
        let app = XCUIApplication()
        app.launch()
        
        // Verifica se o botão existe antes de tocar
        let goToCanvas = app.buttons["GoToCanvasButton"]
        if goToCanvas.exists {
            goToCanvas.tap()
        }
        
        app.buttons["CloseCanvasButton"].tap()
        
        XCTAssertFalse(app.buttons["CloseCanvasButton"].exists)
    }
    
    func testSaveSculpture() {
        let app = XCUIApplication()
        app.launch()
        
        app.buttons["GoToCanvasButton"].tap()
        
        Thread.sleep(forTimeInterval: 1)
        tapCenter(app: app)
        Thread.sleep(forTimeInterval: 0.5)
        
        let botaoSalvar = app.buttons["SaveSculptureButton"]
        XCTAssertTrue(botaoSalvar.exists)
        botaoSalvar.tap()
        
        let tf = app.textFields["SculptureNameTextField"]
        XCTAssertTrue(tf.waitForExistence(timeout: 5.0), "O popup de nomear demorou para aparecer")
        
        tf.tap()
        tf.typeText("Escultura Teste")
        
        let botaoConf = app.buttons["ConfirmSaveButton"]
        XCTAssertTrue(botaoConf.exists)
        botaoConf.tap()
        
        let popupDesapareceu = !tf.waitForExistence(timeout: 2.0)
        XCTAssertTrue(popupDesapareceu, "O popup deveria ter fechado, verifique se há cubos na cena")
    }
    
    func testClearAllCanvas() {
        let app = XCUIApplication()
        app.launch()
        app.buttons["GoToCanvasButton"].tap()
        
        let botao = app.buttons["ClearAllButton"]
        if botao.waitForExistence(timeout: 2.0) {
            botao.tap()
            XCTAssertTrue(app.buttons["ConfirmClearButton"].exists)
        } else {
            XCTFail("Botão ClearAll não encontrado")
        }
    }
}
