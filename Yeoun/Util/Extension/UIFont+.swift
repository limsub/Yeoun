//
//  Font.swift
//  LifeMovie
//
//  Created by 임승섭 on 12/21/24.
//

import UIKit

enum YeounFont: String, CaseIterable {
    case y1     = "NanumGaRamYeonGgoc"
    case y2     = "NanumGangBuJangNimCe"
    case y3     = "NanumGoDigANiGoGoDing"
    case y4     = "NanumGomSinCe"
    case y5     = "NanumGyuRiEuiIrGi"
    case y6     = "NanumGiBbeumBarkEum"
    case y7     = "NanumGimYuICe"
    case y8     = "NanumNaMuJeongWeon"
    case y9     = "NanumNaEuiANaeSonGeurSsi"
    case y10    = "NanumNeuRisNeuRisCe"
    case y11    = "NanumDaSiSiJagHae"
    case y12    = "NanumDongHwaDdoBag"
    case y13    = "NanumDdarEGeEomMaGa"
    case y14    = "NanumMongDor"
    case y15    = "NanumMiRaeNaMu"
    case y16    = "NanumBaReunJeongSin"
    case y17    = "NanumBaeEunHyeCe"
    case y18    = "NanumBeomSomCe"
    case y19    = "NanumYeonJiCe"
    case y20    = "NanumURiDdarSonGeurSsi"
    case y21    = "NanumEuiMiIssNeunHanGeur"
    case y22    = "NanumJarHaGoIssEo"
    case y23    = "NanumJangMiCe"
    case y24    = "NanumHimNaeRaNeunMarBoDan"
    
    // 인덱스를 통해 폰트를 반환하는 함수
    static func font(at index: Int) -> YeounFont {
        let arr = YeounFont.allCases
        // 배열 범위를 벗어난 경우 nil 반환
        guard index >= 0 && index < arr.count else { return .y1 }

        return arr[index]
    }
    
    // 현재 폰트가 몇 번째인지 반환하는 변수
    var index: Int {
        return YeounFont.allCases.firstIndex(of: self) ?? 0
    }
}


// UserDefaults
extension YeounFont {

    private static let userDefaultsKey = "SelectedYeounFont"

    // 현재 설정된 폰트 불러오기
    static var current: YeounFont {
        let storedFont = UserDefaults.standard.string(forKey: userDefaultsKey) ?? YeounFont.y1.rawValue
        return YeounFont(rawValue: storedFont) ?? .y1
    }

    // 폰트 저장하기
    static func set(_ font: YeounFont) {
        UserDefaults.standard.set(font.rawValue, forKey: userDefaultsKey)
    }
    
    
}


extension UIFont {
    static var logo40: UIFont {
        return UIFont(name: YeounFont.current.rawValue, size: 40) ?? UIFont.systemFont(ofSize: 40)
    }
    
    static var body32: UIFont {
         return UIFont(name: YeounFont.current.rawValue, size: 32) ?? UIFont.systemFont(ofSize: 32)
     }
    
    static var body28: UIFont {
         return UIFont(name: YeounFont.current.rawValue, size: 28) ?? UIFont.systemFont(ofSize: 28)
     }
    
    static var body24: UIFont {
         return UIFont(name: YeounFont.current.rawValue, size: 24) ?? UIFont.systemFont(ofSize: 24)
     }

     static var body20: UIFont {
         return UIFont(name: YeounFont.current.rawValue, size: 20) ?? UIFont.systemFont(ofSize: 20)
     }

     static var body18: UIFont {
         return UIFont(name: YeounFont.current.rawValue, size: 18) ?? UIFont.systemFont(ofSize: 18)
     }

     static var body16: UIFont {
         return UIFont(name: YeounFont.current.rawValue, size: 16) ?? UIFont.systemFont(ofSize: 16)
     }

     static var body14: UIFont {
         return UIFont(name: YeounFont.current.rawValue, size: 14) ?? UIFont.systemFont(ofSize: 14)
     }

     static var body12: UIFont {
         return UIFont(name: YeounFont.current.rawValue, size: 12) ?? UIFont.systemFont(ofSize: 12)
     }
}
