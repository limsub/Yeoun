//
//  SummaryViewManager.swift
//  LifeMovie
//
//  Created by 임승섭 on 1/21/25.
//


import UIKit
/*
class SummaryViewManager: UIViewController {
    
    var titleStr: String        = ""
    var images: [String]        = []
    
    var group = DispatchGroup()
    
    // MARK: - UI Component
    let baseView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        return view
    }()
    
    let titleLabel = {
        let view = UILabel()
        view.font = .mg16    // TODO: - 머니그라피 or 다른 폰트로 바꾸기
        view.text = "# 꼭 봐야 하는 영화들"
        view.textColor = .label
        return view
    }()
    
    lazy var collectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: self.makeCollectionViewFlowLayout())
        view.dataSource = self
        view.register(UICollectionViewCell.self, forCellWithReuseIdentifier: UICollectionViewCell.description())
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isScrollEnabled = false
        return view
    }()
    
    let watermarkLabel = {
        let view = UILabel()
        view.font = .mg20
        view.text = "인생드라마"
        view.textColor = .label
        return view
    }()
    
    init(titleStr: String, images: [String]) {
        self.titleStr = titleStr
        self.images = images
        
        super.init(nibName: nil, bundle: nil)
        
        self.layouts()
        self.configures()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layouts() {
        // MARK: - Layout
        [titleLabel, collectionView, watermarkLabel].forEach {
            baseView.addSubview($0)
        }
        
        
        let w = (UIScreen.main.bounds.width - 32) / 5
        let h = w * 1.5 * 4 + 12 + 48 + 16 + 20 + 6
        baseView.snp.makeConstraints { make in
            make.width.equalTo(UIScreen.main.bounds.width)
            make.height.greaterThanOrEqualTo(h)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(18)
            make.horizontalEdges.equalToSuperview().inset(12)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(8)
        }
        watermarkLabel.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(12)
        }
    }
    
    func configures() {
        titleLabel.text = titleStr
    }

    func shareSummaryView() {
        self.makeSummaryView() { view in
            let activityVC = UIActivityViewController(
                activityItems: [view.asImage()],
                applicationActivities: nil
            )
            
            UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true)
        }
    }
    
    private func makeSummaryView(completion: @escaping (UIView) -> Void) {
    
        print("before : ",  collectionView.contentSize.height)
        collectionView.reloadData()
        collectionView.layoutIfNeeded()
        collectionView.reloadData()
        print("after : ",  collectionView.contentSize.height)
        
        let totalHeight = collectionView.contentSize.height +
            titleLabel.intrinsicContentSize.height +
            watermarkLabel.intrinsicContentSize.height +
                    64 // Spacing and padding adjustments
                
        
        baseView.layoutIfNeeded()
        
        collectionView.snp.makeConstraints { make in
            make.height.equalTo(collectionView.contentSize.height)
        }
        collectionView.layoutIfNeeded()
        print("collectionView height : ", collectionView.frame.height)
        
        baseView.layoutIfNeeded()
        
        baseView.snp.makeConstraints { make in
//            make.top.equalTo(titleLabel.snp.top).offset(-12)
//            make.bottom.equalTo(watermarkLabel.snp.bottom).offset(-12)
//            make.width.equalTo(UIScreen.main.bounds.width)
//            make.height.greaterThanOrEqualTo(baseView.snp.width)
            make.height.equalTo(totalHeight)
            
            print("baseView height222  : ", baseView.frame.height)
        }
        
        print("totalHeight : ", totalHeight)
        

        
        print("baseView height : ", baseView.frame.height)
        
        group.notify(queue: .main) {
            print("complete")
            completion(self.baseView)
        }
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [self] in // Ensure layout updates
//            completion(baseView)
//        }

    }
    
    private func makeCollectionViewFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let w = (UIScreen.main.bounds.width - 32) / 5
        layout.itemSize = CGSize(
            width: w,
            height: w * 1.5
        )
        layout.minimumInteritemSpacing = 4
        layout.minimumLineSpacing = 4
        return layout
    }
}

extension SummaryViewManager: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        group.enter()
        print("cellForRowAt : ", indexPath.item)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UICollectionViewCell.description(), for: indexPath)
        
        print("cellForRowAt22 : ", indexPath.item)
        
        let imageView = UIImageView()
        imageView.loadImage(self.images[indexPath.row]) {
            self.group.leave()
            print("complete loading : ", indexPath.row)
        }
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 4
        
        cell.contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        return cell
    }
    
}

extension UIView {
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}

*/
