//
//  ORK_CheckerApp.swift
//  ORK Checker
//  Created by Ilya Komarov on 24.11.2021.
//

import SwiftUI
import AppKit
import LaunchAtLogin

/// MAGICAL VALUES
let maximumInterval : Float = 3600
let minimumInterval : Float = 60
let precisionRound : Float = 3
let menuBarFontSize = 13
let iconSize = 16
/// MAGICAL VALUES

/// DEFAULT PREFERENCES
let contractDefault = "0xCed0CE92F4bdC3c2201E255FAF12f05cf8206dA8"
let API = "https://api.pancakeswap.info/api/v2/tokens/"
let pngPathDefault = "ORK"
let delaySecDefault = 60.0
let autostartDefault = false
let tickerDefault = "ORK"
/// DEFAULT PREFERENCES

/// GLOBAL OBJECTS
var statusItem: NSStatusItem?
var icon : NSImage?
var timer : Timer?
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
    var pngPath : String
    var ticker : String
    var autostart : Bool
    init() {
        self.contract = defaults.string(forKey: "contract") ?? contractDefault
        let delaySec = defaults.double(forKey: "delaySec")
        if (delaySec == 0) {
            self.delaySec = delaySecDefault
        }
        else {
            self.delaySec = delaySec
        }
        self.pngPath = defaults.string(forKey: "pngPath") ?? pngPathDefault
        self.ticker = defaults.string(forKey: "ticker") ?? tickerDefault
        self.autostart = defaults.bool(forKey: "autostart")
    }
}
/// PREFERENCES

/// Default preferences
var prefs = Preferences()

/// Saved preferences
var defaults = UserDefaults.standard

/// Fuction for getting information through Pancakeswap API
func get_price() {
    // Answer struct init
    var ans = Answer()
    let url = URL(string: API + prefs.contract)!
    let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
        guard let _ = data else {return}
        ans.data = data
        ans.response = response
        ans.error = error
        DispatchQueue.main.async {
            display_data(ans: ans)
        }
    }
    task.resume()
}
///

/// Function for saving preferences from Defaults (not complete)
func save_prefs(contract : String, delaySec : Double, pngPath : String, ticker : String, autostart: Bool) {
    defaults.set(contract, forKey: "contract")
    defaults.set(delaySec, forKey: "delaySec")
    defaults.set(pngPath, forKey: "pngPath")
    defaults.set(ticker, forKey: "ticker")
    defaults.set(autostart, forKey: "autostart")
    prefs.contract = contract
    prefs.delaySec = delaySec
    prefs.pngPath = pngPath
    prefs.ticker = ticker
    prefs.autostart = autostart
    // Change timer interval
    timer?.invalidate()
    infinity_timer(time: delaySec)
    // Autostart
    LaunchAtLogin.isEnabled = autostart
}
///

/// Function for checking fields from "Preferences" (not complete)
func check_data(delaySec : String) -> (Bool, String) {
    let delay = Float(delaySec)
    if (delay == nil) {
        return (true, "Oops. Entered delay is not a number.")
    }
    if (delay! < minimumInterval) {
        return (true, "Oops. Delay must be " + String(Int(minimumInterval)) + " seconds at least.")
    }
    if (delay! > maximumInterval) {
        return (true, " Oops. Delay must be less than " + String(Int(maximumInterval)) + " seconds.")
    }
    return (false, "Data verified.")
}
///

/// Function for displaying data on menu bar
func display_data(ans : Answer) {
    // Getting data from Answer struct
    let statusCode = (ans.response as? HTTPURLResponse)?.statusCode ?? -1
    let data = ans.data
    let _ = ans.error
    if (statusCode != 200) {
        icon = NSImage(named: prefs.pngPath)
        icon?.size = NSSize(width: iconSize, height: iconSize)
        statusItem?.button?.imagePosition = NSControl.ImagePosition.imageLeft
        statusItem?.button?.image = icon
        statusItem?.button?.title = " Pancake error"
        return
    }
    if (data != nil) {
        // Json serializing
        if let statusesArray = try? JSONSerialization.jsonObject(with: ans.data!, options: .allowFragments) as? [String: Any],
           let data = statusesArray["data"] as? [String: Any],
           let price = data["price"] as? String {
            let _price_ = roundf((price as NSString).floatValue*pow(10, precisionRound))/pow(10, precisionRound)
            // Building icon
            icon = NSImage(named: prefs.pngPath)
            icon?.size = NSSize(width: iconSize, height: iconSize)
            //Building button
            statusItem?.button?.imagePosition = NSControl.ImagePosition.imageLeft
            statusItem?.button?.image = icon
            statusItem?.button?.title = " " + prefs.ticker + " $" + String(_price_)
        }
    }
}
///

/// Infinity loop function
func infinity_timer(time: Double) {
    get_price()
    timer = Timer.scheduledTimer(withTimeInterval: time, repeats: true) { (t) in
        get_price()
    }
}
///

/// Class AppDelegate
class AppDelegate: NSObject, NSApplicationDelegate {
    
    var popover: NSPopover!
    
    /// Function when app did launching
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Building button
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusItem?.button?.font = NSFont.systemFont(ofSize: CGFloat(menuBarFontSize))
        statusItem?.button?.title = "Loading price"
        // Create the popover and sets ContentView as the rootView
        let contentView = ContentView()
        let popover = NSPopover()
        popover.contentSize = NSSize(width: 400, height: 500)
        popover.behavior = .transient
        popover.contentViewController = NSHostingController(rootView: contentView)
        self.popover = popover
        statusItem?.button?.action = #selector(togglePopover(_:))
    }
    ///
    
    /// Function for popover
    @objc func togglePopover(_ sender: AnyObject?) {
        if let button = statusItem?.button {
            if self.popover.isShown {
                self.popover.performClose(sender)
            } else {
                self.popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
            }
        }
    }
    ///
    
}
///

/// Main function
@main
struct ORK_CheckerApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        Settings {
            AnyView(erasing: ContentView())
        }
    }
    let result: () = infinity_timer(time: prefs.delaySec)
}
///
