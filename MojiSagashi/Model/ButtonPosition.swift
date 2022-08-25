//
//  ButtonPosition.swift
//  MojiSagashi
//
//  Created by 村中令 on 2022/08/23.
//

import Foundation
import UIKit

struct ButtonPosition {
    var minX: CGFloat
    var maxX: CGFloat
    var minY: CGFloat
    var maxY: CGFloat

    func isOverlap(labelPosition: ButtonPosition) -> Bool {
        let rangeX = minX...maxX
        let rangeY = minY...maxY

        let isOverlapMinX = rangeX.contains(labelPosition.minX)
        let isOverlapMaxX = rangeX.contains(labelPosition.maxX)
        let isOverlapMinY = rangeY.contains(labelPosition.minY)
        let isOverlapMaxY = rangeY.contains(labelPosition.maxY)

        if isOverlapMinX && isOverlapMinY { return true }
        if isOverlapMinX && isOverlapMaxY { return true }
        if isOverlapMaxX && isOverlapMinY { return true }
        if isOverlapMaxX && isOverlapMaxY { return true }
        return false
    }
}
