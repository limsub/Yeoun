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
    
    let titleLabel = UILabel().then {
        $0.font = .body24
        $0.numberOfLines = 0
    }
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
        
        [titleLabel, seperatorView, textView].forEach {
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
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(18)
            make.horizontalEdges.equalToSuperview().inset(24)
//            make.height.equalTo(30)
        }
        
        seperatorView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.height.equalTo(1)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        
        textView.snp.makeConstraints { make in
            make.top.equalTo(seperatorView.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(50)
            make.bottom.equalToSuperview().inset(24)
//            make.bottom.equalTo(self.safeAreaLayoutGuide).inset(10)
        }
    }
    
    func setUp(_ title: String) {
        titleLabel.text = title
        setTextViewHeight()
    }
}

// MARK: - UITextView
extension MakeDetailView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        setTextViewHeight()
    }
}

// MARK: - privaet func
extension MakeDetailView {
    private func setTextViewHeight() {
        Logger.print(#function)
        let size = CGSize(width: self.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        
        // height 수정
        textView.constraints.forEach { constraint in
            if constraint.firstAttribute == .height {
                constraint.constant = estimatedSize.height
                Logger.print("height : \(estimatedSize.height)")
            }
        }
    }
}
