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
        
        TextField("String", text: $contract, onCommit: {
            print("commit")
        })
                    .textFieldStyle(.roundedBorder)
                    .textCase(.uppercase)
                    .padding(.horizontal)

        Text("Ticker PNG Url:")
        
        TextField("Url", text: $pngUrl, onCommit: {
            
        })
                    .textFieldStyle(.roundedBorder)
                    .textCase(.uppercase)
                    .padding(.horizontal)
        
        Text("Coin Ticker:")
        
        TextField("Ticker", text: $ticker, onCommit: {
            
        })
                    .textFieldStyle(.roundedBorder)
                    .textCase(.uppercase)
                    .padding(.horizontal)
        
        Text("Delay in seconds:")
        
        TextField("Secs", text: $delaySec, onCommit: {
            
        })
                    .textFieldStyle(.roundedBorder)
                    .textCase(.uppercase)
                    .padding(.horizontal)
        
        Toggle(isOn: $autostart) {
                Text("Start with system")
            }
        
        Button("Save changes") {
            let (answer, text) = check_data()
            if (answer) {
                
            }
            else {
                
            }
            print("Button tapped!")
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
