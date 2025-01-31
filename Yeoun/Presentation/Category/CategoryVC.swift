//
//  CategoryVC.swift
//  Yeoun
//
//  Created by 임승섭 on 1/25/25.
//

import UIKit
import ReactorKit

class CategoryViewController: BaseViewController, View {
    
    let mainView = CategoryView()
    let headerView = CategoryHeaderView()
    
    init(reactor: CategoryReactor) {
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBackButton()
        setNavigation()
        setTableView()
        setHeaderView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadData()
    }
}

// MARK: - ReactorKit
extension CategoryViewController {
    func bind(reactor: CategoryReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
    
    private func bindAction(_ reactor: CategoryReactor) {
        mainView.plusButton.rx.tap
            .subscribe(with: self) { owner , _ in
                if let id = owner.reactor?.currentState.categoryItem?.id {
                    let reactor = MakeDetailReactor(categoryID: id)
                    let vc = MakeDetailViewController(reactor: reactor)
                    let nav = UINavigationController(rootViewController: vc)
                    nav.modalPresentationStyle = .fullScreen
                    owner.present(nav, animated: true)
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: CategoryReactor) {
        reactor.state.map { $0.categoryItem }
            .distinctUntilChanged()
            .subscribe(with: self) { owner , item in
                if item != nil {
                    Logger.print("mainView reload")
                    owner.setHeaderView()   // 여기서 실행시키면 headerView에 대한 binding이 여러 번 걸리긴 하는데, 그게 뭐 앱 터칠 건 아니니까 걍 넘어가자. 흐린눈~
                    owner.mainView.tableView.reloadData()
                }
            }
            .disposed(by: disposeBag)
    }
}

extension CategoryViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: - cell
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let cnt = reactor?.currentState.categoryItem?.detailIdList.count else {
            // TODO: - show popup
            return 0
        }
        Logger.print("\(cnt)")
        return cnt
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.description()) as? CategoryTableViewCell else { return UITableViewCell() }
        
        guard let item = reactor?.currentState.categoryItem?.detailIdList[indexPath.row] else { return UITableViewCell() }
        
        cell.setUp(item: item)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let id = reactor?.currentState.categoryItem?.detailIdList[indexPath.row].id {
            let r = DetailReactor(detailID: id)
            let vc = DetailViewController(reactor: r)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    // MARK: - header
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 110
    }
}

// MARK: - private func
extension CategoryViewController {
    private func setTableView() {
        self.mainView.tableView.delegate = self
        self.mainView.tableView.dataSource = self
    }
    
    private func setHeaderView() {
        guard let item = reactor?.currentState.categoryItem else { return }
        
        headerView.frame = CGRect(x: 0, y: 0, width: 0, height: 110)
        headerView.setUp(item: item)
        
        self.mainView.tableView.tableHeaderView = headerView
        
        // bind
        headerView.titleTextField.rx.text.orEmpty
            .debounce(.milliseconds(5), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(with: self) { owner , text  in
                owner.reactor?.action.onNext(.updateTitle(title: text))
            }
            .disposed(by: disposeBag)
        
        headerView.subtitleTextField.rx.text.orEmpty
            .debounce(.milliseconds(5), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(with: self) { owner , text  in
                owner.reactor?.action.onNext(.updateSubtitle(subtitle: text))
            }
            .disposed(by: disposeBag)
    }
    
    private func setNavigation() {
        let rightBarButton = UIBarButtonItem(
            image: .dotMenuButton,
            style: .plain,
            target: self,
            action: #selector(showDeletePopUp)
        )
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    @objc
    private func showDeletePopUp() {
        let popup = ReportPopupViewController(
            title: String(localized: "해당 카테고리를 삭제하시겠습니까?"),
            message: String(localized: "삭제하면 다시 복구할 수 없어요"),
            cancelTitle: String(localized: "취소"),
            actionTitle: String(localized: "삭제"),
            cancelHandler: {
                print("취소 버튼 눌림")
            },
            actionHandler: {
                print("신고하기 버튼 눌림")
                self.reactor?.action.onNext(.deleteData)
                self.navigationController?.popViewController(animated: true)
            }
        )

        popup.modalPresentationStyle = .overFullScreen
        popup.modalTransitionStyle = .crossDissolve
        present(popup, animated: true, completion: nil)
    }
    
    private func loadData() {
        reactor?.action.onNext(.loadData)
    }
}
