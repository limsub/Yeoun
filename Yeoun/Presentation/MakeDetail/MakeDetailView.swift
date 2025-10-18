//
//  MakeDetailView.swift
//  Yeoun
//
//  Created by 임승섭 on 1/25/25.
//

import UIKit

class MakeDetailView: BaseBackgroundView {
    
    let scrollView = UIScrollView().then {
        $0.keyboardDismissMode = .onDrag
        $0.showsVerticalScrollIndicator = false
    }
    let contentView = UIView()
    
    let titleTextField = DetailViewPosterTextField(
        font: .body24,
        placeholder: String(localized: "제목을 입력해주세요")
    )
    
    let seperatorView = {
        let view = UIView()
        view.backgroundColor = .lightGray.withAlphaComponent(0.5)
        return view
    }()
    
    lazy var textView = YeounTextView().then {
        $0.delegate = self
    }
    
    deinit {
        // 메모리 누수 방지
        NotificationCenter.default.removeObserver(self)
    }
    
    override func addSubViews() {
        super.addSubViews()
        
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [titleTextField, seperatorView, textView].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func layouts() {
        super.layouts()
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide)
            make.horizontalEdges.bottom.equalTo(self.safeAreaLayoutGuide)
        }
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.height.greaterThanOrEqualTo(self.snp.height).priority(.low)
            make.width.equalTo(scrollView.snp.width)
        }
        titleTextField.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(18)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        
        seperatorView.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(20)
            make.height.equalTo(1)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        
        textView.snp.makeConstraints { make in
            make.top.equalTo(seperatorView.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.greaterThanOrEqualTo(self.snp.height).priority(.low)
            make.bottom.equalToSuperview().inset(24)
        }
    }
    
    func setUp(_ title: String) {

    }
}

// MARK: - UITextView
extension MakeDetailView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {

    }
}
