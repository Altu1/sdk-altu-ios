//
//  BaseComponentsTests.swift
//  AltuSDKTests
//
//  Created by Ricardo Caldeira on 28/04/22.
//

import XCTest
import UIKit
@testable import AltuSDK

class BaseComponentTests: XCTestCase {

    var mockStackview: UIStackView!

    override func setUp() {
        super.setUp()
        self.mockStackview = UIStackView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))

        loadCustomFonts(for: "otf")
        loadCustomFonts(for: "ttf")
        
    }

    override func tearDown() {
        self.mockStackview = nil
    }

    func addComponentToStackView(component: ComponentPresenterModel) {
        self.mockStackview.updateComponentView(component: component, resetView: false)
        component.configureData()
    }

    func loadImage(name: String) -> UIImage? {
        let bundleComponents = Bundle(identifier: "com.d1.AltuSDK")
        
        if let image = UIImage(named: name, in: bundleComponents, compatibleWith: nil) {
            return image
        }
        
        let bundleHelper = Bundle(identifier: "com.d1.AltuSDK")
        
        if let image = UIImage(named: name, in: bundleHelper, compatibleWith: nil) {
            return image
        }

        return nil
    }

    func getComponent<T: ComponentPresenterView, P: ComponentPresenterModelImpl<T>>(stackView: UIStackView?, identifier: String) -> P? {
        let presenterView = stackView?.arrangedSubviews.filter({ view -> Bool in
            if let presenterView = view as? T {
                if presenterView.presenter?.componentIdentifier == identifier {
                    return true
                }
            }
            return false
        }).first as? T

        return presenterView?.presenter as? P
    }

    @discardableResult
    func loadCustomFonts(for fontExtension: String) -> Bool {
        let fileManager = FileManager.default
        if let bundleURL = Bundle(identifier: "com.d1.AltuSDK")?.bundleURL {
            do {
                let contents = try fileManager.contentsOfDirectory(at: bundleURL, includingPropertiesForKeys: [], options: .skipsHiddenFiles)
                for url in contents where url.pathExtension == fontExtension {
                    guard let fontData = NSData(contentsOf: url) else {
                        continue
                    }
                    if let provider = CGDataProvider(data: fontData), let font = CGFont(provider) {
                        CTFontManagerRegisterGraphicsFont(font, nil)
                    }
                }
            } catch {
                print("error: \(error)")
            }
        }
        return true
    }
}

