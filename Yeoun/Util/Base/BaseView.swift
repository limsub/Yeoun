//
//  BaseView.swift
//  TTOON
//
//  Created by 임승섭 on 4/5/24.
//

import UIKit
import Then

class BaseView: UIView {
    var height = UIScreen.main.bounds.height
    var width = UIScreen.main.bounds.width
    lazy var safeGuide = safeAreaLayoutGuide
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubViews()
        layouts()
        configures()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubViews() { }
    func layouts() { }
    func configures() { }
}

// MARK: - backgroundView
class BaseBackgroundView: UIView {
    var height = UIScreen.main.bounds.height
    var width = UIScreen.main.bounds.width
    lazy var safeGuide = safeAreaLayoutGuide
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setPaperImage()
        addSubViews()
        layouts()
        configures()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setPaperImage() {
        let imageView = UIImageView().then {
            $0.image = .backgroundImage
            $0.contentMode = .scaleAspectFill
        }
        
        self.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func addSubViews() { }
    func layouts() { }
    func configures() {
        self.backgroundColor = .clear 
    }
}
