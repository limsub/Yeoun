//
//  DetailView.swift
//  Yeoun
//
//  Created by 임승섭 on 1/25/25.
//

import UIKit

class DetailView: BaseBackgroundView {

    let scrollView = UIScrollView().then {
        $0.keyboardDismissMode = .onDrag
        $0.showsVerticalScrollIndicator = false
    }
    let contentView = UIView()
    
    lazy var textView = YeounTextView().then {
        $0.delegate = self
    }
    let dateLabel = UILabel().then {
        $0.font = .body18
    }
    
    override func addSubViews() {
        super.addSubViews()
        
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [textView, dateLabel].forEach {
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
        
        textView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(18)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(50)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(textView.snp.bottom).offset(18)
            make.trailing.equalToSuperview().inset(32)
            make.bottom.equalToSuperview().inset(24)
        }
    }
    
    func setUp(_ item: DetailItem) {
        textView.text = item.content
        dateLabel.text = item.date.toDate(to: .detailDTODate)?.toDetailViewLocalized()
        setTextViewHeight()
    }
}


// MARK: - UITextView
extension DetailView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        setTextViewHeight()
    }
}


// MARK: - private func
extension DetailView {
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


class YeounTextView: UITextView {
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        configures()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configures() {
        font = .body24
        isScrollEnabled = false
        backgroundColor = .clear
        tintColor = .mainBrown
    }
}
