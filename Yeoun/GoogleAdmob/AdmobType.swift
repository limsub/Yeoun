//
//  AdmobType.swift
//  Yeoun
//
//  Created by 임승섭 on 10/18/25.
//

import UIKit
import GoogleMobileAds

enum AdmobType {
    case homeBanner
    case categoryBanner
    case detailBanner
    
    var AdUnitID: String {
        switch self {
        case .homeBanner:
            return "ca-app-pub-8155830639201287/1392129446"
        case .categoryBanner:
            return "ca-app-pub-8155830639201287/5212341991"
        case .detailBanner:
            return "ca-app-pub-8155830639201287/8134659438"
        }
    }
    
    var testBannerID: String {
        return "ca-app-pub-3940256099942544/2435281174"
    }
}
