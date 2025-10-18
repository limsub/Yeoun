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
        $0.bounces = true
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
    let dateLabel = UILabel().then {
        $0.font = .body14
        $0.textColor = .lightGray
    }
    
    let bannerView = GADBannerViewWrapper(type: .detailBanner)
    
    override func addSubViews() {
        super.addSubViews()
        
        [scrollView, bannerView].forEach {
            addSubview($0)
        }
        scrollView.addSubview(contentView)
        
        [titleTextField, seperatorView, dateLabel, textView].forEach {
            contentView.addSubview($0)
        }
        
        
    }
    
    override func layouts() {
        super.layouts()
        
        bannerView.snp.makeConstraints { make in
            make.bottom.horizontalEdges.equalToSuperview()
        }
        
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
            make.horizontalEdges.equalToSuperview().inset(28)
        }
        
        seperatorView.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(20)
            make.height.equalTo(1)
            make.horizontalEdges.equalToSuperview().inset(28)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(seperatorView.snp.bottom).offset(20)
            make.leading.equalToSuperview().inset(28)
        }
        
        textView.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(18)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.bottom.equalToSuperview().inset(24)
        }
    }
    
    func setUp(_ item: DetailItem) {
        titleTextField.text = item.title
        textView.text = item.content
        dateLabel.text = item.date.toDate(to: .detailDTODate)?.toDetailViewLocalized()
    }
}


// MARK: - UITextView
extension DetailView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {

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
