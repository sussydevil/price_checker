//
//  ContentView.swift
//  ORK Checker
//  Created by Ilya Komarov on 24.11.2021.
//

import SwiftUI

struct ContentView: View {
    init() {print("Hi")}
    @State public var name = "Something"
    var body: some View {
        Label("Contract Address:", systemImage: "folder.circle")
        TextField("Shout your name at me", text: $name)
                    .textFieldStyle(.roundedBorder)
                    .textCase(.uppercase)
                    .padding(.horizontal)
        Label("PNG Url:", systemImage: "folder.circle")
        TextField("Shout your name at me", text: $name)
                    .textFieldStyle(.roundedBorder)
                    .textCase(.uppercase)
                    .padding(.horizontal)
        
        Label("Coin Ticker:", systemImage: "folder.circle")
        TextField("Shout your name at me", text: $name)
                    .textFieldStyle(.roundedBorder)
                    .textCase(.uppercase)
                    .padding(.horizontal)
        
        Label("Delay in seconds:", systemImage: "folder.circle")
        TextField("Shout your name at me", text: $name)
                    .textFieldStyle(.roundedBorder)
                    .textCase(.uppercase)
                    .padding(.horizontal)
        
        Button("Save changes") {
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
