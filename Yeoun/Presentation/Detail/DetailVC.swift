//
//  DetailVC.swift
//  Yeoun
//
//  Created by 임승섭 on 1/25/25.
//

import UIKit
import ReactorKit

class DetailViewController: BaseViewController, View  {
    
    let mainView = DetailView()
    
    
    init(reactor: DetailReactor) {
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBackButton()
        setNavigation()
        hideKeyboardWhenTappedAround()
        setupKeyboardNotifications()
        loadData()
    }
    deinit {
        // 키보드 알림 해제
        NotificationCenter.default.removeObserver(self)
    }
    
}

extension DetailViewController {
    func bind(reactor: DetailReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
    
    private func bindAction(_ reactor: DetailReactor) {
        mainView.textView.rx.text.orEmpty
            .debounce(.milliseconds(5), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .map { DetailReactor.Action.updateData(newContent: $0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: DetailReactor) {
        reactor.state.map { $0.detailItem }
            .distinctUntilChanged { $0?.id == $1?.id }  // 이렇게 해버리면 맨 처음에만 실행되고 나중엔 절대 실행 안될듯.
            .subscribe(with: self) { owner , item in
                if let item {
                    Logger.print("mainView setup")
                    owner.mainView.setUp(item)
                }
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - keyboard
extension DetailViewController {
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

// private func
extension DetailViewController {
    private func setNavigation() {
        let rightBarButton = UIBarButtonItem(
            image: .dotMenuButton,
//            image: UIImage(systemName: "square.and.arrow.down"),
            style: .plain,
            target: self,
            action: #selector(showDeletePopUp)
        )
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    @objc
    private func showDeletePopUp() {
        let popup = ReportPopupViewController(
            title: String(localized: "해당 기록을 삭제하시겠습니까?"),
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






class ReportPopupViewController: UIViewController {

    private let popupView = BaseBackgroundView().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 12
    }
    private let titleLabel = UILabel().then {
        $0.font = .body24
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    private let messageLabel = UILabel().then {
        $0.font = .body18
        $0.textColor = .darkGray
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    private let cancelButton = UIButton(type: .system).then {
        $0.setTitleColor(.mainBrown, for: .normal)
        $0.layer.cornerRadius = 8
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.mainBrown.cgColor
    }
    private let actionButton = UIButton(type: .system).then {
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .mainBrown
        $0.layer.cornerRadius = 8
    }

    private var cancelHandler: (() -> Void)?
    private var actionHandler: (() -> Void)?

    init(title: String, message: String, cancelTitle: String, actionTitle: String, cancelHandler: (() -> Void)?, actionHandler: (() -> Void)?) {
        super.init(nibName: nil, bundle: nil)
        self.titleLabel.text = title
        self.messageLabel.text = message
        self.cancelButton.setTitle(cancelTitle, for: .normal)
        self.actionButton.setTitle(actionTitle, for: .normal)
        self.cancelHandler = cancelHandler
        self.actionHandler = actionHandler
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupLayout()
        setupActions()
    }

    private func setupView() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)

        view.addSubview(popupView)
        
        [titleLabel, messageLabel, cancelButton, actionButton].forEach {
            popupView.addSubview($0)
        }
    }

    private func setupLayout() {
        popupView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(200)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(popupView).offset(24)
            make.horizontalEdges.equalTo(popupView).inset(20)
        }

        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(popupView).inset(20)
        }

        cancelButton.snp.makeConstraints { make in
            make.left.equalTo(popupView).offset(20)
            make.bottom.equalTo(popupView).offset(-20)
            make.height.equalTo(44)
            make.width.equalTo(popupView).multipliedBy(0.43)
        }

        actionButton.snp.makeConstraints { make in
            make.right.equalTo(popupView).offset(-20)
            make.bottom.equalTo(popupView).offset(-20)
            make.height.equalTo(44)
            make.width.equalTo(popupView).multipliedBy(0.43)
        }
    }

    private func setupActions() {
        cancelButton.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        actionButton.addTarget(self, action: #selector(actionHandlerTriggered), for: .touchUpInside)
    }

    @objc private func cancelAction() {
        dismiss(animated: true) {
            self.cancelHandler?()
        }
    }

    @objc private func actionHandlerTriggered() {
        dismiss(animated: true) {
            self.actionHandler?()
        }
    }
}
