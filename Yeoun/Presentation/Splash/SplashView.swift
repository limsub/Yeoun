//
//  SplashView.swift
//  Yeoun
//
//  Created by 임승섭 on 1/26/25.
//

import UIKit


class SplashView: BaseBackgroundView {
    
    let logoLabel = UILabel().then {
        $0.text = String(localized: "여운")
        $0.font = .logo40
    }
    
    let descriptionLabel = UILabel().then {
        $0.text = String(localized: "나의 여운을 기록합니다")
        $0.font = .body24
    }
    
    override func addSubViews() {
        super.addSubViews()
        
        [logoLabel, descriptionLabel].forEach {
            self.addSubview($0)
        }
    }
    
    override func layouts() {
        super.layouts()
        
        logoLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-60)
            make.centerX.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(logoLabel.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
        }
    }
    
    override func configures() {
        super.configures()

    }
}
