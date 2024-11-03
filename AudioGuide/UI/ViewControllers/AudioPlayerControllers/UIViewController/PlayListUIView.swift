//
//  PlayListUIView.swift
//  AudioGuide
//
//  Created by Максим Оліярник on 11.04.2024.
//

import UIKit

class PlayListUIView: UIView {
    let bluredView : UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .regular)
        let view = UIVisualEffectView(effect: blurEffect)
        view.contentMode = .scaleToFill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    public let backBtn : UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "Left"), for: .normal)
        btn.backgroundColor = .clear
        btn.tintColor = .black
        btn.translatesAutoresizingMaskIntoConstraints = false
       return btn
    }()
    public let listAudioCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        // Відступи по краях
        let insets: CGFloat = 17.0
        // Висота екрана айфона помножена на 0.085
        let itemHeight = UIScreen.main.bounds.height * 0.085
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 2 * insets, height: itemHeight)
        layout.sectionInset = UIEdgeInsets(top: 0, left: insets, bottom: 0, right: insets)
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 16
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setUpConstraints(){
        addSubview(bluredView)
        bluredView.contentView.addSubview(backBtn)
        bluredView.contentView.addSubview(listAudioCollectionView)
        NSLayoutConstraint.activate([
            bluredView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bluredView.topAnchor.constraint(equalTo: topAnchor),
            bluredView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bluredView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            backBtn.heightAnchor.constraint(equalToConstant: 32),
            backBtn.widthAnchor.constraint(equalToConstant: 32),
            backBtn.leadingAnchor.constraint(equalTo: bluredView.leadingAnchor,constant: 15),
            backBtn.topAnchor.constraint(equalTo: bluredView.topAnchor,constant: 60),
            
            listAudioCollectionView.leadingAnchor.constraint(equalTo: bluredView.leadingAnchor),
            listAudioCollectionView.topAnchor.constraint(equalTo: bluredView.topAnchor,constant: 108),
            listAudioCollectionView.trailingAnchor.constraint(equalTo: bluredView.trailingAnchor),
            listAudioCollectionView.bottomAnchor.constraint(equalTo: bluredView.bottomAnchor),
        ])
    }
    public func delegateCollectionView(withController controller : UICollectionViewDelegate){
        listAudioCollectionView.delegate = controller
    }
    public func dataSourceCollectionView(withController controller : UICollectionViewDataSource){
        listAudioCollectionView.dataSource = controller
    }
    public func registerCollectionViewCell(with cellClass : AnyClass, and identifier : String){
        listAudioCollectionView.register(cellClass.self, forCellWithReuseIdentifier: identifier)
    }
}
