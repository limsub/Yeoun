//
//  SelectFontView.swift
//  Yeoun
//
//  Created by 임승섭 on 1/26/25.
//

import UIKit
import Then

class SelectFontView: BaseBackgroundView {
    
    let tableView = UITableView(frame: .zero).then {
        $0.register(FontTableViewCell.self, forCellReuseIdentifier: FontTableViewCell.description())
        $0.contentInsetAdjustmentBehavior = .never
        $0.bounces = true
        $0.separatorStyle = .none
        $0.backgroundColor = .clear
        $0.showsVerticalScrollIndicator = false
    }
    
    override func addSubViews() {
        super.addSubViews()
        
        [tableView].forEach {
            self.addSubview($0)
        }
    }
    
    override func layouts() {
        super.layouts()
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
}


class FontTableViewCell: BaseTableViewCell {
    let descriptionLabel = UILabel().then {
        $0.font = .body18
        $0.text = String(localized: "마음에 드는 폰트를 선택해주세요")
    }
    
    let checkImageView = {
        let view = UIImageView()
        view.image = .checkMark
        view.isHidden = true
        return view
    }()
    
    override func addSubViews() {
        super.addSubViews()
        
        [descriptionLabel, checkImageView].forEach { item in
            contentView.addSubview(item)
        }
    }
    
    override func layouts() {
        super.layouts()
        
        checkImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(24)
            make.size.equalTo(24)
            make.centerY.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(21)
            make.trailing.equalTo(checkImageView.snp.leading).offset(-8)
            make.centerY.equalToSuperview()
        }
    }
    
    override func configures() {
        super.configures()
        
        selectionStyle = .none
    }
    
    func setUp(font: YeounFont, isSelected: Bool) {
        if isSelected {
            checkImageView.isHidden = false
        } else {
            checkImageView.isHidden = true
        }
        
        descriptionLabel.font = UIFont(name: font.rawValue, size: 18) ?? UIFont.systemFont(ofSize: 18)
    }
}
