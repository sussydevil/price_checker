//
//  ContentView.swift
//  ORK Checker
//  Created by Ilya Komarov on 24.11.2021.
//

import SwiftUI

struct ContentView: View {
    // View variables
    //
    @Environment(\.dismiss) var dismiss
    @State public var contract = prefs.contract
    @State public var delaySec = String(prefs.delaySec)
    @State public var pngUrl = prefs.pngPath
    @State public var ticker = prefs.ticker
    @State public var autostart = prefs.autostart
    @State public var message = "No errors yet"
    var i = 5
    //
    // View variables
    
    var body: some View {

        VStack {
            Group {
                Text("Contract Address:")
                            .padding()
                            .frame(width: 150, height: 20)
                            
                
                TextField("String", text: $contract)
                            .textFieldStyle(.roundedBorder)
                            .textCase(.uppercase)
                            .padding(.horizontal)
                            .frame(width: 300, height: 20)
                            //.disabled(true)

            }
            
            Group {
                Text("Ticker PNG Url:")
                    .padding()
                    .frame(width: 200, height: 20)
                
                TextField("Ticker PNG Url", text: $pngUrl)
                            .textFieldStyle(.roundedBorder)
                            .textCase(.uppercase)
                            .padding(.horizontal)
                            .frame(width: 300, height: 20)
                            //.disabled(true)
            }
            
            Group {
                Text("Coin Ticker:")
                    .padding()
                    .frame(width: 200, height: 20)
                
                TextField("Coin ticker", text: $ticker)
                            .textFieldStyle(.roundedBorder)
                            .textCase(.uppercase)
                            .padding(.horizontal)
                            .frame(width: 300, height: 20)
                            //.disabled(true)
            }
            
            Group {
                Text("Delay in seconds:")
                    .padding()
                    .frame(width: 200, height: 20)
                 
                TextField("Seconds", text: $delaySec)
                            .textFieldStyle(.roundedBorder)
                            .textCase(.uppercase)
                            .padding(.horizontal)
                            .frame(width: 300, height: 20)
            }
            
            Group {
                Toggle(isOn: $autostart) {
                        Text("Start with system")
                }
                .padding()
                .frame(width: 200, height: 20)
                
                Text("\(message)")
                
                HStack {
                    
                    Button("Save changes") {
                        let (error, text) = check_data(contract: contract, delaySec: delaySec, pngUrl: pngUrl, ticker: ticker, autostart: autostart)
                        if (!error) {
                            message = ""
                            save_prefs(contract: contract, delaySec: Double(delaySec)!, pngPath: pngUrl, ticker: ticker, autostart: autostart)
                        }
                        else {
                            message = text
                        }
                    }
                    .padding()
                    .frame(width: 150, height: 20)
                    
                    Button ("Exit") {
                        exit(0)
                    }
                    
                    .frame(width: 100, height: 20)
                    
                }
                
            }
        }.frame(width: 300, height: 330, alignment: Alignment.center)
        
            
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
        }
    }
}
