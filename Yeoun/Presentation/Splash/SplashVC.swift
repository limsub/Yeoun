//
//  SplashVC.swift
//  Yeoun
//
//  Created by 임승섭 on 1/26/25.
//

import UIKit

class SplashViewController: BaseViewController {
    
    let mainView = SplashView()
    let repo = RealmRepository()
    
    override func loadView() {
        self.view = mainView
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showHomeView()
    }
    
    
}

// MARK: - private func
extension SplashViewController {
    private func showHomeView() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let vc = HomeViewController()
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .overFullScreen
            nav.modalTransitionStyle = .crossDissolve
            self.present(nav, animated: true)
        }
    }
}
