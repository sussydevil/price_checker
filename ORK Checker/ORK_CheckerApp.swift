//
//  ORK_CheckerApp.swift
//  ORK Checker
//  Created by Ilya Komarov on 24.11.2021.
//

import SwiftUI
import AppKit

/// Magical values
let menuBarFontSize = 13
let iconSize = 16
let precisionRound : Float = 3
///


/// DEFAULT PREFERENCES
let API = "https://api.pancakeswap.info/api/v2/tokens/"
let contractDefault = "0xCed0CE92F4bdC3c2201E255FAF12f05cf8206dA8"
let delaySecDefault = 10.0
let pngUrlDefault = "orakuru.png"
let nameDefault = "ORK"
let autostartDefault = true
let isFirstLaunchDefault = true
/// DEFAULT PREFERENCES

/// GLOBAL OBJECTS
var statusItem: NSStatusItem?
var statusBar : NSStatusBar?
var timer : Timer?
var icon : NSImage?
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
    var isFirstLaunch : Bool
    init() {
        self.contract = contractDefault
        self.delaySec = delaySecDefault
        self.pngUrl = pngUrlDefault
        self.ticker = nameDefault
        self.autostart = autostartDefault
        self.isFirstLaunch = isFirstLaunchDefault
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
        // DEBUG
        print(String(data: json_data, encoding: .utf8)!)
        DispatchQueue.main.async {
            display_data(err: err)
        }
    }
    task.resume()
}
///

/// Function for saving preferences from Defaults
func save_prefs() {
    defaults.set(25, forKey: "contract")
    defaults.set(true, forKey: "delaySec")
    defaults.set(CGFloat.pi, forKey: "pngUrl")
    defaults.set("Paul Hudson", forKey: "name")
    defaults.set(true, forKey: "autostart")
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
    prefs.ticker = defaults.string(forKey: "name") ?? nameDefault
    prefs.autostart = defaults.bool(forKey: "autostart")
}
///

/// Function for displaying data on menu bar
func display_data(err: Bool) {
    if (err) {
        statusItem?.button?.title = "Internet Error"
        return
    }
    if (ans.data != nil) {
        if let statusesArray = try? JSONSerialization.jsonObject(with: ans.data!, options: .allowFragments) as? [String: Any],
           let data = statusesArray["data"] as? [String: Any],
           let price = data["price"] as? String {
            let _price_ = roundf((price as NSString).floatValue*pow(10, precisionRound))/pow(10, precisionRound)
            
            icon = NSImage(named: "orakuru")
            icon?.size = NSSize(width: iconSize, height: iconSize)
            icon?.isTemplate = true
            
            statusItem?.button?.imagePosition = NSControl.ImagePosition.imageLeft
            statusItem?.button?.image = icon
            statusItem?.button?.title = " " + prefs.ticker + " $" + String(_price_)
        }
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
    
    /// Function when app did launching
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Building menu
        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "Preferences", action: nil, keyEquivalent: "P"))
        menu.addItem(NSMenuItem(title: "About", action: nil, keyEquivalent: "A"))
        menu.addItem(NSMenuItem(title: "Donate", action: nil, keyEquivalent: "D"))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: Selector("terminate:"), keyEquivalent: "q"))
        // Building button
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        NSApp.setActivationPolicy(.accessory)
        statusItem?.button?.title = "Loading price"
        statusItem?.button?.font = NSFont.systemFont(ofSize: CGFloat(menuBarFontSize))
        statusItem?.menu = menu
    }
    ///

}
///

/// Function for checking fields from "Preferences"
func check_data() -> (Bool, String) {
    //TODO
    return (true, "1")
}
///

/// Main function
@main
struct ORK_CheckerApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    let result: () = infinity_loop(time: prefs.delaySec)
}
///
