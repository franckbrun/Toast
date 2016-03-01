//
//  AppDelegate.swift
//  Toast
//
//  Created by Franck Brun on 29/02/2016.
//  Copyright © 2016 Franck Brun. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

  @IBOutlet weak var window: NSWindow!
  @IBOutlet weak var textField: NSTextField!
  @IBOutlet weak var textColorWell: NSColorWell!
  @IBOutlet weak var backgroundColorWell: NSColorWell!

  func applicationDidFinishLaunching(aNotification: NSNotification) {
    
    let attributes = Toast.defaultAttributes
    self.textColorWell.color = (attributes[Toast.TextColor] as? NSColor) ?? NSColor.whiteColor()
    self.backgroundColorWell.color = (attributes[Toast.BackgroundColor] as? NSColor) ?? NSColor.whiteColor()
  
    self.textField.stringValue = "Toast World !"
  }

  func applicationWillTerminate(aNotification: NSNotification) {
    // Insert code here to tear down your application
  }

  @IBAction func toastIt(sender: AnyObject?) {
    
    var attributes = [String : AnyObject]()
    
    attributes[Toast.TextColor] = textColorWell.color
    attributes[Toast.BackgroundColor] = backgroundColorWell.color
    attributes[Toast.Duration] = 1.5
    
    Toast.show(self.textField.stringValue, attributes: attributes)
    
  }
  
}

