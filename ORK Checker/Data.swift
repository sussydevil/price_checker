//
//  Data.swift
//  ORK Checker
//  Created by Ilya Komarov on 07.12.2021.
//

import Foundation

typealias ContractStruct = (ticker: String, contract: String, pngPath: String)

var contractData: [ContractStruct] =
[("ORK", "0xCed0CE92F4bdC3c2201E255FAF12f05cf8206dA8", "orakuru"),
("MATE", "0x2198b69b36b86f250549d26d69c5957912a34ec2", "mate"),
("BTC", "0x7130d2a12b9bcbfae4f2634d864a1ee1ce3ead9c", "bitcoin"),
("ETH", "0x2170ed0880ac9a755fd29b2688956bd959f933f8", "ethereum"),
("BNB", "0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c", "binance-coin")]
