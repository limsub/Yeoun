//
//  HomeView.swift
//  Yeoun
//
//  Created by 임승섭 on 1/25/25.
//

import UIKit
import ReactorKit
import RxSwift
import Then

class HomeView: BaseBackgroundView {
    
    let tableView = UITableView().then {
        $0.register(HomeTableViewCell.self , forCellReuseIdentifier: HomeTableViewCell.description())
        $0.separatorStyle = .none
        $0.backgroundColor = .clear
        $0.showsVerticalScrollIndicator = false
    }
    
    let plusButton = {
        let view = UIButton()
        view.setImage(.plusButton, for: .normal)
        return view
    }()
    
//    lazy var bannerView = {
//        let view = GADBannerView(adSize: GADAdSizeBanner)
//        view.alpha = 1
//        // test id : ca-app-pub-3940256099942544/2435281174
//        // real id : ca-app-pub-8155830639201287/7653012351
//        let testId = "ca-app-pub-3940256099942544/2435281174"
//        let realId = "ca-app-pub-8155830639201287/7653012351"
//        let isMyDevice = UserDefaults.standard.bool(forKey: "isMyDevice")
//        view.adUnitID = isMyDevice ? testId : realId
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.load(GADRequest())
//        return view
//    }()
    
    
    override func addSubViews() {
        super.addSubViews()
        
        [tableView, plusButton].forEach {
            self.addSubview($0)
        }
    }
    
    override func layouts() {
        super.layouts()
        
//        bannerView.snp.makeConstraints { make  in
//            make.horizontalEdges.equalTo(self)
//            make.bottom.equalTo(self.safeAreaLayoutGuide)
//            make.height.equalTo(60)
//        }
        
        tableView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(self.safeAreaLayoutGuide)
//            make.bottom.equalTo(bannerView.snp.top)
            make.bottom.equalToSuperview()
        }
        
        plusButton.snp.makeConstraints { make in
            make.size.equalTo(60)
            make.trailing.equalTo(self).inset(16)
            make.bottom.equalTo(self).inset(62)    // tabbar 생기면 111
        }
    }
    
}

class HomeTableViewCell: BaseTableViewCell {
    
    // MARK: - UI Components
    let titleLabel = {
        let view = UILabel()
        view.font = .body24
        view.backgroundColor = .clear
        return view
    }()
    
    let subtitleLabel = {
        let view = UILabel()
        view.numberOfLines = 1
        view.font = .body16
        view.backgroundColor = .clear
        return view
    }()
    
    
    // MARK: - Layout
    override func addSubViews() {
        super.addSubViews()
        
        [titleLabel, subtitleLabel].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func layouts() {
        super.layouts()
        
        titleLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(24)
            make.top.equalToSuperview().inset(20)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(24)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.bottom.equalToSuperview().inset(8)
        }
    }
    
    override func configures() {
        super.configures()
        
        contentView.backgroundColor = .clear
        self.selectionStyle = .none
    }
    
    
    // MARK: - setup
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.disposeBag = DisposeBag()
    }
    
    func setUp(_ item: CategoryItem) {
        titleLabel.text = item.title
        subtitleLabel.text = item.subtitle
    }
}
