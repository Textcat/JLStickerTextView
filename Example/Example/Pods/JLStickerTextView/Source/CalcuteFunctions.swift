//
//  CalcuteFunctions.swift
//  stickerTextView
//
//  Created by 刘业臻 on 16/4/20.
//  Copyright © 2016年 luiyezheng. All rights reserved.
//

import Foundation
import UIKit

class CalculateFunctions {
    static func CGRectGetCenter(rect: CGRect) -> CGPoint{
        return CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect))
    }
    
    static func CGRectScale(rect: CGRect, wScale: CGFloat, hScale: CGFloat) -> CGRect {
        return CGRectMake(rect.origin.x * wScale, rect.origin.y * hScale, rect.size.width * wScale, rect.size.height * hScale)
    }
    
    static func CGpointGetDistance(point1: CGPoint, point2: CGPoint) -> CGFloat {
        let fx = point2.x - point1.x
        let fy = point2.y - point1.y
        
        return sqrt((fx * fx + fy * fy))
    }
    
    static func CGAffineTrasformGetAngle(t: CGAffineTransform) -> CGFloat{
        return atan2(t.b, t.a)
    }
    
    static func CGAffineTransformGetScale(t: CGAffineTransform) -> CGSize {
        return CGSizeMake(sqrt(t.a * t.a + t.c + t.c), sqrt(t.b * t.b + t.d * t.d))
    }
    
}
