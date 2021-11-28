//
//  ContentView.swift
//  ORK Checker
//  Created by Ilya Komarov on 24.11.2021.
//

import SwiftUI

/*
struct LoadView: View {
    @State public var remaining = 4.0
    @Environment(\.dismiss) var dismiss
    
    
    var body: some View {
        VStack {
            Image(nsImage: loadImage!)
        }
        .onReceive(Timer.publish(every: 0.01, on: .current, in: .default).autoconnect()) { _ in
                    self.remaining -= 0.01
                    if self.remaining <= 0 {
                        self.dismiss()
                    }
    }
}
}
*/

struct ContentView: View {
    // View variables
    //
    @Environment(\.dismiss) var dismiss
    @State public var contract = prefs.contract
    @State public var delaySec = String(prefs.delaySec)
    @State public var pngUrl = prefs.pngUrl
    @State public var ticker = prefs.ticker
    @State public var autostart = prefs.autostart
    @State public var message = ""
    var i = 5
    //
    // View variables
    
    var body: some View {

        VStack {
            Group {
                Text("Contract Address:")
                            .padding()
                            .frame(width: 200, height: 30)
                            
                
                TextField("String", text: $contract)
                            .textFieldStyle(.roundedBorder)
                            .textCase(.uppercase)
                            .padding(.horizontal)
                            //.disabled(true)

            }
            
            Group {
                Text("Ticker PNG Url:")
                    .padding()
                    .frame(width: 200, height: 30)
                
                TextField("Ticker PNG Url", text: $pngUrl)
                            .textFieldStyle(.roundedBorder)
                            .textCase(.uppercase)
                            .padding(.horizontal)
                            .disabled(true)
            }
            
            Group {
                Text("Coin Ticker:")
                    .padding()
                    .frame(width: 200, height: 30)
                
                TextField("Coin ticker", text: $ticker)
                            .textFieldStyle(.roundedBorder)
                            .textCase(.uppercase)
                            .padding(.horizontal)
                            //.disabled(true)
            }
            
            Group {
                Text("Delay in seconds:")
                    .padding()
                    .frame(width: 200, height: 30)
                 
                TextField("Seconds", text: $delaySec)
                            .textFieldStyle(.roundedBorder)
                            .textCase(.uppercase)
                            .padding(.horizontal)
            }
            
            Group {
                Toggle(isOn: $autostart) {
                        Text("Start with system")
                }
                .padding()
                .frame(width: 200, height: 30)
                
                Button("Save changes") {
                    let (error, text) = check_data(contract: contract, delaySec: delaySec, pngUrl: pngUrl, ticker: ticker, autostart: autostart)
                    if (!error) {
                        message = "All OK"
                        
                        save_prefs(contract: contract, delaySec: Double(delaySec)!, pngUrl: pngUrl, ticker: ticker, autostart: autostart)
                    }
                    else {
                        message = text
                    }
                }
                .padding()
                .frame(width: 200, height: 30)
                
                Text("\(message)")
            }
            
        }.frame(width: 350, height: 400, alignment: Alignment.center)
        
            
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
        }
    }
}
