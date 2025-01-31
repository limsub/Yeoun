//
//  MakeCategoryView.swift
//  Yeoun
//
//  Created by 임승섭 on 1/25/25.
//

import UIKit

class MakeCategoryView: BaseBackgroundView {
    
    let descriptionLabel = UILabel().then {
        $0.text = String(localized: "새로운 카테고리의 이름과 설명을 적어주세요")
        $0.font = .body20
        $0.numberOfLines = 0
    }
    
    let titleTextField = DetailViewPosterTextField(
        font: .body32,
        placeholder: String(localized: "이름을 입력해주세요")
    )
    let titleBottomBorder = UIView().then {
        $0.backgroundColor = .mainBrown
    }
    let subtitleTextField = DetailViewPosterTextField(
        font: .body24,
        placeholder: String(localized: "설명을 입력해주세요")
    )
    let subtitleBottomBorder = UIView().then {
        $0.backgroundColor = .mainBrown
    }
    
    override func addSubViews() {
        super.addSubViews()
        
        [descriptionLabel, titleTextField, titleBottomBorder, subtitleTextField, subtitleBottomBorder].forEach {
            self.addSubview($0)
        }
    }
    
    override func layouts() {
        super.layouts()
            
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).inset(32)
            make.horizontalEdges.equalToSuperview().inset(28)
        }
        
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview().inset(28)
        }
        titleBottomBorder.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(titleTextField)
            make.height.equalTo(1)
        }
        
        subtitleTextField.snp.makeConstraints { make in
            make.top.equalTo(titleBottomBorder.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview().inset(28)
        }
        subtitleBottomBorder.snp.makeConstraints { make in
            make.top.equalTo(subtitleTextField.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(subtitleTextField)
            make.height.equalTo(1)
        }
        
    }
    
}
