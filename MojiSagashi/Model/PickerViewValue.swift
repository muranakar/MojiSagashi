//
//  PickerViewValue.swift
//  MojiSagashi
//
//  Created by 村中令 on 2022/08/22.
//

import Foundation

struct PickerViewRow {
    static func load() -> Int? {
        let key = "pickerViewRow"
        let loadCoin = UserDefaults.standard.integer(forKey: key)
        return loadCoin
    }
    static func save(row: Int) {
        let key = "pickerViewRow"
        UserDefaults.standard.set(row, forKey: key)
    }
}
