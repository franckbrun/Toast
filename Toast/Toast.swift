//
//  Toast.swift
//
//  Created by Franck Brun on 22/02/2016.
//  Copyright © 2016 Franck Brun. All rights reserved.
//

import Cocoa

public typealias ToastAttributes = [String : AnyObject]

public class Toast : NSObject {

  public static let TextColor = "TextColor"
  public static let BackgroundColor = "BackgroundColor"
  public static let Duration = "Duration"
  public static let Image = "Image"
  
  public static var defaultToast = Toast()

  public static let defaultAttributes: ToastAttributes = [
    Toast.TextColor : NSColor.whiteColor(),
    Toast.BackgroundColor : NSColor.darkGrayColor(),
  ]

  public var attributes: ToastAttributes? {
    didSet {
      if self.attributes == nil { self.attributes = Toast.defaultAttributes }
    }
  }
  
  private var window: ToastWindow?
  private var textField: NSTextField = NSTextField(frame: NSRect.zero)
  
  class func show(text: String, attributes : ToastAttributes? = nil) {
    Toast.defaultToast.attributes = attributes
    Toast.defaultToast.show(text)
  }
  
  override public init() {
    super.init()
    let contentRect = NSRect(x: 0, y: 0, width: 10, height: 10)
    self.window = ToastWindow(contentRect: contentRect, styleMask: NSBorderlessWindowMask, backing: .Buffered, `defer`: false)

    self.window?.contentView = RoundedBackgroundView(frame: NSRect(x: 0, y: 0, width: 10, height: 10))
    self.window?.contentView?.subviews = [self.textField]

    self.textField.bordered = false
    self.textField.bezeled = false
    self.textField.selectable = false
    self.textField.drawsBackground = false
    self.textField.backgroundColor = NSColor.clearColor()
  }

  public func show(text: String) {
    
    if let backgroundView = self.window?.contentView as? RoundedBackgroundView {
      backgroundView.backgroundColor = (attributes?[Toast.BackgroundColor] as? NSColor) ?? NSColor.darkGrayColor()
    }
    
    self.textField.font = NSFont.systemFontOfSize(50)
    self.textField.textColor = (attributes?[Toast.TextColor] as? NSColor) ?? NSColor.whiteColor()
    
    self.textField.stringValue = text
    self.textField.sizeToFit()
    let textRect = self.textField.frame
    let windowContentRect = textRect.insetBy(dx: -20, dy: -20)
    self.window?.setContentSize(windowContentRect.size)
    self.textField.setFrameOrigin(NSPoint(x: (windowContentRect.width - textRect.width) * 0.5 , y: (windowContentRect.height - textRect.height) * 0.5))

    self.window?.alphaValue = 1.0
    
    self.window?.center()
    self.window?.makeKeyAndOrderFront(nil)
    
    if let _window = self.window {
      _window.animations["alphaValue"] = nil

      let animation = CABasicAnimation(keyPath: "alphaValue")
      animation.fromValue = 1.0
      animation.toValue = 0.0
      
      var animDuration = 1.0
      if let duration = (attributes?[Toast.Duration] as? NSNumber)?.doubleValue {
        if duration > 0 && duration < 2.0 { animDuration = duration }
      }
      
      animation.duration = animDuration
      animation.delegate = self
      
      _window.animations["alphaValue"] = animation

      _window.animator().alphaValue = 0.0
    }
  }
  
  override public func animationDidStop(anim: CAAnimation, finished flag: Bool) {
    if flag {
      self.window?.orderOut(nil)
    }
  }
  
}

class ToastWindow: NSWindow {

  override var canBecomeKeyWindow: Bool {
    return false
  }
  
  override init(contentRect: NSRect, styleMask aStyle: Int, backing bufferingType: NSBackingStoreType, `defer` flag: Bool) {
    super.init(contentRect: contentRect, styleMask: aStyle, backing: bufferingType, `defer`: flag)
    internalInit()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    internalInit()
  }

  func internalInit() {
    self.level = Int(CGWindowLevelForKey(.StatusWindowLevelKey))
    self.opaque = false
    self.hasShadow = false
    self.excludedFromWindowsMenu = true
    self.backgroundColor = NSColor.clearColor()
    self.ignoresMouseEvents = true
  }
  
}

class RoundedBackgroundView : NSView {
  
  override var opaque: Bool {
    return false
  }
  
  var backgroundColor = NSColor.darkGrayColor() {
    didSet {
      needsDisplay = true
    }
  }
  
  override func drawRect(dirtyRect: NSRect) {
    let bezierPath = NSBezierPath()
    bezierPath.appendBezierPathWithRoundedRect(self.bounds, xRadius: 20, yRadius: 20)
    self.backgroundColor.setFill()
    bezierPath.fill()
  }
  
}