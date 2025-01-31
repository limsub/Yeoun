//
//  SelectFontVC.swift
//  Yeoun
//
//  Created by 임승섭 on 1/26/25.
//

import UIKit
import ReactorKit


class SelectFontViewController: BaseViewController, View {
    
    
    let mainView = SelectFontView()
    
    init(reactor: SelectFontReactor) {
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
        
        setTableView()
        setNavigation()
    }
}

// MARK: - ReactorKit
extension SelectFontViewController {
    func bind(reactor: SelectFontReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
    
    private func bindAction(_ reactor: SelectFontReactor) {
        
    }
    
    private func bindState(_ reactor: SelectFontReactor) {
        reactor.state.map { $0.currentSelectedFont }
            .distinctUntilChanged()
            .subscribe(with: self) { owner , _ in
                owner.mainView.tableView.reloadData()
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - TableView
extension SelectFontViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return YeounFont.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FontTableViewCell.description(), for: indexPath) as? FontTableViewCell else { return UITableViewCell() }

        cell.setUp(
            font: YeounFont.allCases[indexPath.row],
            isSelected: indexPath.row == reactor?.currentState.currentSelectedFont
        )
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        reactor?.action.onNext(.selectFont(indexPath.row))
        
    }
}


// MARK: - Navigation
extension SelectFontViewController {
    private func setNavigation() {
        let cancelButton = UIBarButtonItem(
            title: String(localized: "취소"),
            style: .plain,
            target: self,
            action: #selector(cancelButtonClicked)
        )
        
        let saveButton = UIBarButtonItem(
            title: String(localized: "저장"),
            style: .plain ,
            target: self ,
            action: #selector(saveButtonClicked)
        )
        
        self.navigationItem.leftBarButtonItem = cancelButton
        self.navigationItem.rightBarButtonItem = saveButton
        
        setNavigationTintColor(.mainBrown)
    }
    
    @objc
    private func cancelButtonClicked() {
        print(#function)
        self.dismiss(animated: true)
    }
    
    @objc
    private func saveButtonClicked() {
        print(#function)
        reactor?.action.onNext(.saveFontToUD)
        
        // Reset view and show splash
        guard let window = UIApplication.shared.connectedScenes
            .filter({ $0.activationState == .foregroundActive })
            .first(where: { $0 is UIWindowScene }) as? UIWindowScene,
              let keyWindow = window.windows.first else { return }

        let vc = SplashViewController()
        let nav = UINavigationController(rootViewController: vc)
        keyWindow.rootViewController = nav
        keyWindow.makeKeyAndVisible()
        
        UIView.transition(with: keyWindow, duration: 0.5, options: .transitionCrossDissolve, animations: nil, completion: nil)
    }
}


// MARK: - private func
extension SelectFontViewController {
    private func setTableView() {
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
    }
}
