//
//  CharacterType.swift
//  MojiSagashi
//
//  Created by 村中令 on 2022/08/23.
//

import Foundation

enum CharacterType {
    case number
    case letter

    func string() -> String {
        switch self {
        case .number:
            return NSLocalizedString("characterTypeNumber", comment: "")
        case .letter:
            return NSLocalizedString("characterTypeLetter", comment: "")
        }
    }

}
