//
//  ViewController.swift
//  LCNotificationBannerDemo
//
//  Created by DevLiuSir on 2021/6/24.
//

    

import Cocoa

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            LCNotificationBanner.shared.bgColor = NSColor.controlAccentColor.cgColor
            LCNotificationBanner.shared.position = .top
            LCNotificationBanner.shared.iconSize = 20
            LCNotificationBanner.shared.titleFontSize = 14
            LCNotificationBanner.showSuccessWithStatus("This is a banner title", style: .dark, to: self.view.window)
            
            
//            LCNotificationBanner.showErrorWithStatus("This is a banner title", style: .dark, to: self.view.window)
//            LCNotificationBanner.showInfoWithStatus("This is a banner title", style: .dark, to: self.view.window)
//            LCNotificationBanner.showWarningWithStatus("This is a banner title", style: .dark, to: self.view.window)
//            LCNotificationBanner.showTextWithStatus("This is a banner title", to: self.view.window)
            
        }
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

