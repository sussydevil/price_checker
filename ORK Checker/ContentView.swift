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
    @State private var delaySec = String(Int(prefs.delaySec))
    @State private var autostart = prefs.autostart
    @State private var message = "Data is correct"
    @State private var selectedContract = prefs.contract
    @State private var selectedTicker = prefs.ticker
    //TODO get from data not from here
    let tickers = ["ORK", "MATE", "BTC", "ETH", "BNB"]
    let addresses =
                   ["0xced0ce92f4bdc3c2201e255faf12f05cf8206da8", "0x2198b69b36b86f250549d26d69c5957912a34ec2", "0x7130d2a12b9bcbfae4f2634d864a1ee1ce3ead9c", "0x2170ed0880ac9a755fd29b2688956bd959f933f8", "0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c"]
    //
    // View variables
    
    var body: some View {
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
                            .onChange(of: selectedTicker) {newValue in
                                let index = tickers.firstIndex(of: selectedTicker)
                                selectedContract = addresses[index!]
                            }
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
                
                HStack {
                    
                    Button("Save changes") {
                        let (error, text) = check_data(delaySec: delaySec)
                        if (!error) {
                            message = "Data is correct"
                            save_prefs(contract: selectedContract, delaySec: Double(delaySec)!, pngPath: selectedTicker, ticker: selectedTicker, autostart: autostart)
                        }
                        else {
                            message = text
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
                
                Image("doge_img")
                    .resizable()
                    .frame(width: 330, height: 330, alignment: Alignment.center)
                    .opacity(0.65)
                    .cornerRadius(10)
                    .blur(radius: 2)
                    .overlay(ImageOverlay(), alignment: .center)
            }
        }.frame(width: 380, height: 620, alignment: Alignment.center)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
        }
    }
}
