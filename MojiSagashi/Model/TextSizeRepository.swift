//
//  CoinRepository.swift
//  LineConnectingGame
//
//  Created by 村中令 on 2022/06/18.
//

import Foundation

struct TextSizeRepository {
    static func load() -> Int? {
        let key = "textSize"
        let loadCoin = UserDefaults.standard.integer(forKey: key)
        if loadCoin == 0 { return nil }
        return loadCoin
    }
    static func save(textSize: Int) {
        let key = "textSize"
        UserDefaults.standard.set(textSize, forKey: key)
    }
}
