//
//  MakeCategoryVC.swift
//  Yeoun
//
//  Created by 임승섭 on 1/25/25.
//

import UIKit

class MakeCategoryViewController: BaseViewController {
    
    let mainView = MakeCategoryView()
    let reactor = MakeCategoryReactor()
 
    // MARK: - LifeCycle
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigation()
        hideKeyboardWhenTappedAround()
        setKeyboardFirstRespond()
        bind(reactor: reactor)
    }
    
}

// MARK: - ReactorKit
extension MakeCategoryViewController {
    func bind(reactor: MakeCategoryReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
    
    private func bindAction(_ reactor: MakeCategoryReactor) {
        
    }
    
    private func bindState(_ reactor: MakeCategoryReactor) {
        
    }
}

// MARK: - navigation
extension MakeCategoryViewController {
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
        let id = Date().toString(of: .dtoID)
        let newItem: CategoryItem = .init(
            id: id,
            title: mainView.titleTextField.text ?? "",
            subtitle: mainView.subtitleTextField.text ?? "",
            detailIdList: []
        )
        reactor.action.onNext(.saveNewCategory(item: newItem))
        self.dismiss(animated: true)
    }
}


// MARK: - private func
extension MakeCategoryViewController {
    private func setKeyboardFirstRespond() {
        mainView.titleTextField.becomeFirstResponder()
    }
}
