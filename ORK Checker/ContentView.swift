//
//  ContentView.swift
//  ORK Checker
//  Created by Ilya Komarov on 24.11.2021.
//

import SwiftUI

struct ContentView: View {
    // View variables
    //
    //@Environment(\.dismiss) var dismiss
    @State public var delaySec = String(prefs.delaySec)
    @State public var autostart = prefs.autostart
    @State public var message = "Data is correct"
    @State public var selectedContract = prefs.contract
    @State private var selectedTicker = prefs.ticker
    //@State private var selectedContract = prefs.contract
    let tickers = ["ORK", "MATE", "BTC", "ETH", "BNB"]
    let addresses = ["0xced0ce92f4bdc3c2201e255faf12f05cf8206da8", "0x2198b69b36b86f250549d26d69c5957912a34ec2", "0x7130d2a12b9bcbfae4f2634d864a1ee1ce3ead9c", "0x2170ed0880ac9a755fd29b2688956bd959f933f8", "0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c"]
    //
    // View variables
    
    var body: some View {

        VStack {
            Group {
                Text("Coin Ticker Name:")
                    .frame(height: 20)
            
            Picker("", selection: $selectedTicker) {
                                    ForEach(tickers, id: \.self) {
                                        Text($0)
                                    }
                                }
            .frame(width: 300, height: 20)
            .onChange(of: selectedTicker) {newValue in
                print("Ticker changed to \(selectedTicker)!")
            }
            }
            
            Group {
                Text("Contract Address:")
                            .frame(width: 300, height: 20)
                            
                TextField("String", text: $selectedContract)
                            .textFieldStyle(.roundedBorder)
                            .textCase(.uppercase)
                            .padding(.horizontal)
                            .frame(width: 380, height: 20)
                            .disabled(true)
                            .onChange(of: selectedTicker) {newValue in
                                let index = tickers.firstIndex(of: selectedTicker)
                                selectedContract = addresses[index!]
                            }
            }
    
            Group {
                Text("Interval Between Requests:")
                    .frame(height: 20)
                 
                TextField("Seconds", text: $delaySec)
                            .textFieldStyle(.roundedBorder)
                            .textCase(.uppercase)
                            .padding(.horizontal)
                            .frame(width: 380, height: 20)
            }
            
            Group {
                Toggle(isOn: $autostart) {
                        Text("Start With System")
                }
                .frame(height: 20)
                
                Text("\(message)")
                    .frame(width: 350, height: 40)
                    .border(Color.gray)
                
                HStack {
                    
                    Button("Save changes") {
                        let (error, text) = check_data(delaySec: delaySec)
                        if (!error) {
                            message = "Data is correct"
                            save_prefs(contract: selectedContract, delaySec: Double(delaySec)!, pngPath: selectedTicker, ticker: selectedTicker, autostart: autostart)
                        }
                        else {
                            message = text
                        }
                    }
                    .padding()
                    .frame(width: 150, height: 20)
                    
                    Button (" Exit                ") {
                        exit(0)
                    }
                    .frame(width: 150, height: 20)
                }
            }
        }.frame(width: 380, height: 300, alignment: Alignment.center)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
        }
    }
}
