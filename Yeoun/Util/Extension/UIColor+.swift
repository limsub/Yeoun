//
//  UIColor+.swift
//  LifeMovie
//
//  Created by 임승섭 on 12/26/24.
//

import UIKit

extension UIColor {
    static let mainBrown = UIColor(hexString: "#DCC1A1")!
}

extension UIColor {
    /// r,g,b,a 값을 보내면 알아서 255로 나눠줘서 보여주는 메서드
    convenience init?(r: Int, g: Int, b: Int, a: Int) {
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }

    /// r,g,b 값을 보내면 알아서 255로 나눠줘서 보여주는 메서드
    convenience init(r: Int, g: Int, b: Int) {
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: 1)
    }

    /// 그레이스케일만 설정해주는 메서드
    convenience init(w: Int) {
        self.init(white: CGFloat(w) / 255, alpha: 1)
    }

    /// 16진수로 색상설정 (예: 0xf0f0 )
    convenience init(hex16: UInt16) {
        let alpha = CGFloat((hex16 >> 12) & 0xF) / 0xF
        let red = CGFloat((hex16 >> 8) & 0xF) / 0xF
        let green = CGFloat((hex16 >> 4) & 0xF) / 0xF
        let blue = CGFloat(hex16 & 0xF) / 0xF
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }

    /// 32진수로 색상설정 (예: hex16: 0xff0ffff0)
    convenience init(hex32: UInt32) {
        let alpha = CGFloat((hex32 >> 24) & 0xFF) / 0xFF
        let red = CGFloat((hex32 >> 16) & 0xFF) / 0xFF
        let green = CGFloat((hex32 >> 8) & 0xFF) / 0xFF
        let blue = CGFloat(hex32 & 0xFF) / 0xFF
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }

    /// 16진수 문자열로 색상 설정 (예: hexString: "#221144")
    convenience init?(hexString: String) {
        if !hexString.hasPrefix("#") {
            return nil
        }
        var hexStr = hexString
        hexStr.remove(at: hexStr.startIndex)
        switch hexStr.count {
        case 3:
            hexStr = "f" + hexStr
            fallthrough

        case 4:
            guard let hex16 = UInt16(hexStr, radix: 16) else {
                return nil
            }
            self.init(hex16: hex16)

        case 6:
            hexStr = "ff" + hexStr
            fallthrough

        case 8:
            guard let hex32 = UInt32(hexStr, radix: 16) else {
                return nil
            }
            self.init(hex32: hex32)

        default:
            return nil
        }
    }
}

