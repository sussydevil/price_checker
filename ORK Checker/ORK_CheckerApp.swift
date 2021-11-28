//
//  ORK_CheckerApp.swift
//  ORK Checker
//  Created by Ilya Komarov on 24.11.2021.
//

import SwiftUI
import AppKit

/// MAGICAL VALUES
let menuBarFontSize = 13
let iconSize = 16
let precisionRound : Float = 3
let minimumInterval : Float = 30
let maximumInterval : Float = 3600
/// MAGICAL VALUES


/// DEFAULT PREFERENCES
let API = "https://api.pancakeswap.info/api/v2/tokens/"
let contractDefault = "0xCed0CE92F4bdC3c2201E255FAF12f05cf8206dA8"
let delaySecDefault = 10.0
let pngUrlDefault = "orakuru"
let nameDefault = "ORK"
let autostartDefault = true
/// DEFAULT PREFERENCES

/// GLOBAL OBJECTS
var statusItem: NSStatusItem?
var statusBar : NSStatusBar?
var timer : Timer?
var icon : NSImage?
var loadImage: NSImage?
/// GLOBAL OBJECTS

/// API ANSWER
struct Answer {
    var data: Data?
    var response: URLResponse?
    var error : Error?
}
/// API ANSWER

/// PREFERENCES
struct Preferences {
    var contract : String
    var delaySec : Double
    var pngUrl : String
    var ticker : String
    var autostart : Bool
    init() {
        self.contract = contractDefault
        self.delaySec = delaySecDefault
        self.pngUrl = pngUrlDefault
        self.ticker = nameDefault
        self.autostart = autostartDefault
    }
}
/// PREFERENCES

/// Default preferences
var prefs = Preferences()

/// Answer struct init
var ans = Answer()

/// Saved preferences
var defaults = UserDefaults.standard

/// Fuction for getting information through Pancakeswap API
func get_price() {
    var err = false
    let url = URL(string: API + prefs.contract)!
    let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
        guard let json_data = data else {
            err = true
            return
        }
        ans.data = data
        ans.response = response
        ans.error = error
        #if DEBUG
        print(String(data: json_data, encoding: .utf8)!)
        #endif
        DispatchQueue.main.async {
            display_data(err: err)
        }
    }
    task.resume()
}
///

/// Function for saving preferences from Defaults
func save_prefs(contract : String, delaySec : Double, pngUrl : String, ticker : String, autostart: Bool) {
    defaults.set(contract, forKey: "contract")
    defaults.set(delaySec, forKey: "delaySec")
    //TODO поменять время таймера, поменять иконку
    defaults.set(pngUrl, forKey: "pngUrl")
    defaults.set(ticker, forKey: "ticker")
    defaults.set(autostart, forKey: "autostart")
}
///

/// Function for loading preferences from Defaults
func load_prefs() {
    prefs.contract = defaults.string(forKey: "contract") ?? contractDefault
    let delaySec = defaults.double(forKey: "delaySec")
    if (delaySec == 0) {
        prefs.delaySec = delaySecDefault
    }
    prefs.pngUrl = defaults.string(forKey: "pngUrl") ?? pngUrlDefault
    prefs.ticker = defaults.string(forKey: "ticker") ?? nameDefault
    prefs.autostart = defaults.bool(forKey: "autostart")
}
///

/// Function for checking fields from "Preferences"
func check_data(contract : String, delaySec : String, pngUrl : String, ticker : String, autostart: Bool) -> (Bool, String) {
    
    // Check contract address
    if (contract.count > 45 || contract.count < 40) {
        return (true, "Contract error")
    }
    
    // Check delay
    // ------------------------
    let delay = Float(delaySec)
    if (delay == nil) {
        return (true, "Delay is not a number")
    }
    if (delay! < minimumInterval) {
        return (true, "Delay must be " + String(Int(minimumInterval)) + " seconds at least")
    }
    if (delay! > maximumInterval) {
        return (true, " Delay must be less than" + String(Int(maximumInterval)) + "seconds")
    }
    // ------------------------
    //
    
    // Check PNG
    if (pngUrl == "1") {
        return (true, "PNG Url error")
    }
    
    // Check ticker
    // ------------------------
    if (ticker.count > 5) {
        return (true, "Ticker error")
    }
    // ------------------------
    //
    
    return (false, "OK")
}
///

/// Function for displaying data on menu bar
func display_data(err: Bool) {
    if (err) {
        statusItem?.button?.title = "Internet Error"
        return
    }
    if (ans.data != nil) {
        // Json serializing
        if let statusesArray = try? JSONSerialization.jsonObject(with: ans.data!, options: .allowFragments) as? [String: Any],
           let data = statusesArray["data"] as? [String: Any],
           let price = data["price"] as? String {
            let _price_ = roundf((price as NSString).floatValue*pow(10, precisionRound))/pow(10, precisionRound)
            // Building icon
            icon = NSImage(named: prefs.pngUrl)
            icon?.size = NSSize(width: iconSize, height: iconSize)
            icon?.isTemplate = true
            //Building button
            statusItem?.button?.imagePosition = NSControl.ImagePosition.imageLeft
            statusItem?.button?.image = icon
            statusItem?.button?.title = " " + prefs.ticker + " $" + String(_price_)
        }
    }
    else {
        statusItem?.button?.title = "Internet Error"
    }
}
///

/// Infinity loop function
func infinity_loop(time: Double) {
    get_price()
    timer = Timer.scheduledTimer(withTimeInterval: time, repeats: true) { (t) in
        get_price()
    }
}
///

/// Class AppDelegate
class AppDelegate: NSObject, NSApplicationDelegate {
    
    // popover
        var popover: NSPopover!
    
    /// Function when app did launching
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Building menu
        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "Preferences", action: nil, keyEquivalent: "P"))
        menu.addItem(NSMenuItem(title: "About", action: nil, keyEquivalent: "A"))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.shared.terminate), keyEquivalent: "q"))
        // Building button
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusItem?.button?.title = "Loading price"
        statusItem?.button?.font = NSFont.systemFont(ofSize: CGFloat(menuBarFontSize))
        statusItem?.menu = menu
        
        
        
        
        
        
        // Create the SwiftUI view (i.e. the content).
                let contentView = ContentView()

                // Create the popover and sets ContentView as the rootView
                let popover = NSPopover()
                popover.contentSize = NSSize(width: 400, height: 500)
                popover.behavior = .transient
                popover.contentViewController = NSHostingController(rootView: contentView)
                self.popover = popover
                
                
                if let button = statusItem?.button {
                    button.image = NSImage(named: "Icon")
                    button.action = #selector(togglePopover(_:))
                }
        
    }
    ///

    
// Toggles popover
@objc func togglePopover(_ sender: AnyObject?) {
    if let button = statusItem?.button {
        if self.popover.isShown {
            self.popover.performClose(sender)
        } else {
            self.popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
        }
    }
}
    
}
///

/// Main function
@main
struct ORK_CheckerApp: App {
    init() {
        loadImage = NSImage(named: "orakuru_loading")
        load_prefs()
    }
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
            // IMPORTANT
            Settings {
                AnyView(erasing: ContentView())
            }
        }
    
    let result: () = infinity_loop(time: prefs.delaySec)
}
///
