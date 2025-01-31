//
//  HomeVC.swift
//  Yeoun
//
//  Created by 임승섭 on 1/25/25.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa

class HomeViewController: BaseViewController, View  {
    
    let mainView = HomeView()
    let reactor = HomeReactor()

    // MARK: - LifeCycle
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBackButton()
        setNavigation()
        setTableView()
        bind(reactor: reactor)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadData()
    }
}

// MARK: - ReactorKit
extension HomeViewController {
    func bind(reactor: HomeReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
    
    private func bindAction(_ reactor: HomeReactor) {
        mainView.plusButton.rx.tap
            .subscribe(with: self) { owner , _ in
                let vc = MakeCategoryViewController()
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .fullScreen
                owner.present(nav, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: HomeReactor) {
        reactor.state.map { $0.categoryItemList }
            .subscribe(with: self) { owner , items  in
                owner.mainView.tableView.reloadData()
            }
            .disposed(by: disposeBag)
    }
}


// MARK: - TableView
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reactor.currentState.categoryItemList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.description()) as? HomeTableViewCell else { return UITableViewCell() }
        
        let item = reactor.currentState.categoryItemList[indexPath.row]
        cell.setUp(item)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let id = reactor.currentState.categoryItemList[indexPath.item].id
        let reactor = CategoryReactor(categoryID: id)
        let vc = CategoryViewController(reactor: reactor)
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - private func
extension HomeViewController {
    private func setTableView() {
        self.mainView.tableView.delegate = self
        self.mainView.tableView.dataSource = self
    }
    
    private func setNavigation() {
        let rightBarButton = UIBarButtonItem(
            image: .settingButton,
            style: .plain,
            target: self,
            action: #selector(showSettingView)
        )
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    @objc
    private func showSettingView() {
        let vc = SelectFontViewController(reactor: SelectFontReactor())
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true)
    }
    
    private func loadData() {
        reactor.action.onNext(.loadData)
    }
}
