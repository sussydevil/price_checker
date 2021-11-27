//
//  ContentView.swift
//  ORK Checker
//  Created by Ilya Komarov on 24.11.2021.
//

import SwiftUI

struct ContentView: View {
    
    // View variables
    //
    @State public var contract = prefs.contract
    @State public var delaySec = String(prefs.delaySec)
    @State public var pngUrl = prefs.pngUrl
    @State public var ticker = prefs.ticker
    @State public var autostart = prefs.autostart
    @State public var message = ""
    //
    // View variables
    
    var body: some View {
        
        Text("Contract Address:")
        
        TextField("String", text: $contract)
                    .textFieldStyle(.roundedBorder)
                    .textCase(.uppercase)
                    .padding(.horizontal)
                    .disabled(true)

        Text("Ticker PNG Url:")
        
        TextField("Url", text: $pngUrl)
                    .textFieldStyle(.roundedBorder)
                    .textCase(.uppercase)
                    .padding(.horizontal)
                    .disabled(true)
        
        Text("Coin Ticker:")
        
        TextField("Ticker", text: $ticker)
                    .textFieldStyle(.roundedBorder)
                    .textCase(.uppercase)
                    .padding(.horizontal)
                    .disabled(true)
        
        Text("Delay in seconds:")
        
        TextField("Secs", text: $delaySec)
                    .textFieldStyle(.roundedBorder)
                    .textCase(.uppercase)
                    .padding(.horizontal)
        
        Toggle(isOn: $autostart) {
                Text("Start with system")
        }
        
        Button("Save changes") {
            let (error, text) = check_data(contract: contract, delaySec: delaySec, pngUrl: pngUrl, ticker: ticker, autostart: autostart)
            if (!error) {
                save_prefs(contract: contract, delaySec: Double(delaySec)!, pngUrl: pngUrl, ticker: ticker, autostart: autostart)
            }
            else {
                message = text
                print(message)
            }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
        }
    }
}
