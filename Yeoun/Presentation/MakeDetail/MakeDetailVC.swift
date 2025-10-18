//
//  MakeDetailVC.swift
//  Yeoun
//
//  Created by 임승섭 on 1/25/25.
//

import UIKit
import ReactorKit

class MakeDetailViewController: BaseViewController, View {

    let mainView = MakeDetailView()
    
    init(reactor: MakeDetailReactor) {
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
        
        loadData()
        setNavigation()
        hideKeyboardWhenTappedAround()
        setupKeyboardNotifications()
        setKeyboardFirstRespond()
    }
}

// MARK: - ReactorKit
extension MakeDetailViewController {
    func bind(reactor: MakeDetailReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
    
    private func bindAction(_ reactor: MakeDetailReactor) {
        
    }
    
    private func bindState(_ reactor: MakeDetailReactor) {
        reactor.state.map { $0.categoryTitle }
            .subscribe(with: self) { owner , text  in
                owner.mainView.setUp(text)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - keyboard
extension MakeDetailViewController {
    private func setupKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc
    private func keyboardWillShow(_ notification: Notification) {
        print(#function)
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let keyboardHeight = keyboardFrame.height
        
        // 키보드 높이에 따라 텍스트뷰의 inset 조정
        mainView.scrollView.contentInset.bottom = keyboardHeight
        mainView.scrollView.verticalScrollIndicatorInsets.bottom = keyboardHeight
        
        // 커서 위치를 키보드 위로 올리기
        if let selectedRange = mainView.textView.selectedTextRange {
            mainView.textView.scrollRangeToVisible(mainView.textView.selectedRange)
            DispatchQueue.main.async {
                let caretRect = self.mainView.textView.caretRect(for: selectedRange.start)
                self.mainView.scrollView.scrollRectToVisible(caretRect, animated: true)
            }
        }
    }
    
    @objc
    private func keyboardWillHide(_ notification: Notification) {
        print(#function)
        // 키보드가 내려갈 때 inset 초기화
        mainView.scrollView.contentInset.bottom = 0
        mainView.scrollView.verticalScrollIndicatorInsets.bottom = 0
    }
}

// MARK: - navigation
extension MakeDetailViewController {
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
        self.dismiss(animated: true)
    }
    
    @objc
    private func saveButtonClicked() {
        let id = Date().toString(of: .dtoID)
        let newItem: DetailItem = .init(
            id: id ,
            title: mainView.titleTextField.text ?? "",
            content: mainView.textView.text ?? "",
            date: Date().toString(of: .detailDTODate)
        )
        reactor?.action.onNext(.saveNewDetail(item: newItem))
        self.dismiss(animated: true)
    }
}

// MARK: - private func
extension MakeDetailViewController {
    private func setKeyboardFirstRespond() {
        mainView.textView.becomeFirstResponder()
    }
    
    private func loadData() {
        reactor?.action.onNext(.loadData)
    }
}
