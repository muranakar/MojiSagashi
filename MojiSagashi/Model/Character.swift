//
//  Character.swift
//  MojiSagashi
//
//  Created by 村中令 on 2022/08/21.
//

import Foundation
import UIKit


struct Character {
    static func loadJapaneseLetter() -> [String] {
        let allArray = [
            "あ","い","う","え","お",
            "か","き","く","け","こ",
            "さ","し","す","せ","そ",
            "た","ち","つ","て","と",
            "な","に","ぬ","ね","の",
            "は","ひ","ふ","へ","ほ",
            "ま","み","む","め","も",
            "や","ゆ","よ",
            "ら","り","る","れ","ろ",
            "わ","を","ん"
        ]
        if UIDevice.current.userInterfaceIdiom == .phone {
            return Array(allArray.prefix(20))
        }else if UIDevice.current.userInterfaceIdiom == .pad{
            return allArray
        } else {
            fatalError()
        }
    }

    static func loadEnglishLetter() -> [String] {
        return [
            "A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"
        ]
    }

    static func loadNumbers() -> [String] {

        if DeviceType.isIPhone() {
           // 使用デバイスがiPhoneの場合
            let numbers = Array(1...20)
            let numberString =  numbers.map { String($0) }
            return numberString
        } else if DeviceType.isIPad() {
           // 使用デバイスがiPadの場合
            let numbers = Array(1...50)
            let numberString =  numbers.map { String($0) }
            return numberString
        } else {
            fatalError()
        }
    }
}
