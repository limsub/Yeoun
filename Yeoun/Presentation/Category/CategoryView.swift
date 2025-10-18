//
//  CategoryView.swift
//  Yeoun
//
//  Created by 임승섭 on 1/25/25.
//

import UIKit

class CategoryView: BaseBackgroundView {
    
    let tableView = UITableView(frame: .zero).then {
        $0.register(CategoryTableViewCell.self , forCellReuseIdentifier: CategoryTableViewCell.description())
        $0.contentInsetAdjustmentBehavior = .never
        $0.bounces = true
        $0.separatorStyle = .none
        $0.keyboardDismissMode = .onDrag
        $0.backgroundColor = .clear
        $0.showsVerticalScrollIndicator = false
    }
    
    let plusButton = {
        let view = UIButton()
        view.setImage(.plusButton, for: .normal)
        return view
    }()
    
    let bannerView = GADBannerViewWrapper(type: .categoryBanner)
    
    override func addSubViews() {
        super.addSubViews()
        
        [tableView, plusButton, bannerView].forEach {
            self.addSubview($0)
        }
    }
    
    override func layouts() {
        super.layouts()
        
        bannerView.snp.makeConstraints { make in
            make.bottom.equalTo(self)
            make.horizontalEdges.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide)
            make.top.equalTo(self.safeAreaLayoutGuide)
            make.bottom.equalTo(bannerView.snp.top)
        }
        
        plusButton.snp.makeConstraints { make in
            make.size.equalTo(60)
            make.trailing.equalTo(self).inset(16)
            make.bottom.equalTo(self).inset(62)
        }
    }
    
    
}


// MARK: - TableViewCell
class CategoryTableViewCell: BaseTableViewCell {
    
    let firstSentenceLabel = UILabel().then {
        $0.font = .body20
        $0.numberOfLines = 1
    }
    
    let dateLabel = UILabel().then {
        $0.font = .body16
    }
    
    override func addSubViews() {
        super.addSubViews()
        
        [firstSentenceLabel, dateLabel].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func layouts() {
        super.layouts()
        
        firstSentenceLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(8)
            make.trailing.equalToSuperview().inset(32)
        }
    }
    
    override func configures() {
        super.configures()
        
        contentView.backgroundColor = .clear
        self.selectionStyle = .none
    }
    
    func setUp(item: DetailItem) {
//        self.firstSentenceLabel.text = item.content
        
        // title이 없으면 content의 값을 사용
        if (item.title.isEmpty) {
            self.firstSentenceLabel.text = item.content
        } else {
            self.firstSentenceLabel.text = item.title
        }
        
        self.dateLabel.text = item.date
            .toDate(to: .detailDTODate)?
            .toString(of: .detailCellDateFormat)
    }
}


// MARK: - HeaderView
class CategoryHeaderView: BaseView {
    
    let titleTextField = DetailViewPosterTextField(
        font: .body24,
        placeholder: String(localized: "이름을 입력해주세요")
    )
    let subtitleTextField = DetailViewPosterTextField(
        font: .body16,
        placeholder: String(localized: "설명을 입력해주세요")
    )
    let seperatorView = {
        let view = UIView()
        view.backgroundColor = .lightGray.withAlphaComponent(0.5)
        return view
    }()
    
    override func addSubViews() {
        [titleTextField, subtitleTextField, seperatorView].forEach {
            self.addSubview($0)
        }
    }
    
    override func layouts() {
        seperatorView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(18)
            make.bottom.equalToSuperview().inset(8)
            make.height.equalTo(1)
        }
        
        subtitleTextField.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(24)
            make.bottom.equalTo(seperatorView.snp.top).inset(-20)
        }
        
        titleTextField.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(24)
            make.bottom.equalTo(subtitleTextField.snp.top).offset(-12)
        }
    }

    func setUp(item: CategoryItem) {
        self.titleTextField.text = item.title
        self.subtitleTextField.text = item.subtitle
    }
}


// MARK: - Custom TextField
class DetailViewPosterTextField: UITextField {
    
    convenience init(font: UIFont, placeholder: String? = nil) {
        self.init(frame: .zero)
        
        self.font = font
        self.textColor = .black
        self.placeholder = placeholder
        tintColor = .mainBrown
    }
}
