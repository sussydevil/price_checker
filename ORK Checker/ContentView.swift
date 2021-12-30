//
//  ContentView.swift
//  ORK Checker
//  Created by Ilya Komarov on 24.11.2021.
//

import SwiftUI

struct ImageOverlay: View {
    var body: some View {
        Text("Samurai has no goal\nonly the way")
            .font(.custom("Menlo", size: 16))
            .frame(width: 300, height: 100)
            .multilineTextAlignment(.center)
            .lineSpacing(10)
    }
}


struct ContentView: View {
    // View variables
    //
    @State private var selectedContract = prefs.contract
    @State private var delaySec = String(prefs.delaySec)
    @State private var autostart = prefs.autostart
    @State private var selectedTicker = prefs.ticker
    @State private var selectedPngUrl = prefs.pngPath
    
    // data arrays
    var tickers = [String]()
    var addresses = [String]()
    var pngUrls = [String]()
    
    init() {
        for coin in Prefs.Immutable.coinData
        {
            tickers.append(coin[0])
            addresses.append(coin[1])
            pngUrls.append(coin[2])
        }
    }
    //
    // View variables
    
    var body: some View {
        /// VStack starts
        VStack {
            Group {
                Text("Coin Ticker Name:")
                    .frame(height: 20)
                    .font(.custom("Menlo", size: 13))
                
                Picker("", selection: $selectedTicker) {
                    ForEach(tickers, id: \.self) {Text($0)}
                        }
                .frame(width: 360, height: 20)
                .labelsHidden()
                .pickerStyle(SegmentedPickerStyle())
                .onChange(of: selectedTicker) {newValue in
                    let index = tickers.firstIndex(of: selectedTicker)
                    selectedContract = addresses[index!]
                    selectedPngUrl = pngUrls[index!]
                }
            }
            
            Group {
                Text("Contract Address:")
                            .frame(width: 300, height: 20)
                            .font(.custom("Menlo", size: 13))
                            
                TextField("", text: $selectedContract)
                            .textFieldStyle(.roundedBorder)
                            .padding(.horizontal)
                            .frame(width: 390, height: 25)
                            .disabled(true)
            }.multilineTextAlignment(.center)
    
            Group {
                Text("Interval Between Requests:")
                    .frame(height: 20)
                    .font(.custom("Menlo", size: 13))
                 
                TextField(" 60 < Interval < 3600, in seconds", text: $delaySec)
                            .textFieldStyle(.roundedBorder)
                            .padding(.horizontal)
                            .frame(width: 390, height: 25)
            }
            .multilineTextAlignment(.center)
            
            Group {
                Toggle(isOn: $autostart) {
                        Text("Start With System")
                }
                .frame(height: 22)
                .font(.custom("Menlo", size: 13))
                
                /// HStack starts
                HStack {
                    Button("Save changes") {
                        if (!check_data(delaySec: delaySec)) {
                            save_prefs(contract: selectedContract, delaySec: Double(delaySec)!, pngPath: selectedPngUrl, ticker: selectedTicker, autostart: autostart)
                        }
                        else {
                            delaySec = ""
                        }
                    }
                    .padding()
                    .frame(width: 150, height: 30)
                    .font(.custom("Menlo", size: 12))
                 
                    Button ("Exit widget ") {
                        exit(0)
                    }
                    .frame(width: 150, height: 30)
                    .font(.custom("Menlo", size: 12))
                }
                .padding(.bottom, 8)
                /// HStack ends
                
                Image("poster")
                    .resizable()
                    .frame(width: 330, height: 330, alignment: Alignment.center)
                    .opacity(0.65)
                    .cornerRadius(10)
                    .blur(radius: 2)
                    .overlay(ImageOverlay(), alignment: .center)
            }
        }.frame(width: 380, height: 620, alignment: Alignment.center)
        /// VStack ends
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
        }
    }
}
