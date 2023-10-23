//
//  OthersAudioToursTableViewCell.swift
//  AudioGuide
//
//  Created by Максим Оліярник on 14.10.2023.
//

import UIKit
struct CollectionViewCellViewModel {
    let viewModels : [ElemntsColleViewCellViewModel]
}
class OthersAudioToursTableViewCell: UITableViewCell {

    static let identifier = "OthersAudioToursTableViewCell"
    private var viewModels : [ElemntsColleViewCellViewModel] = []
    private let collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(ElementsToursCollectionViewCell.self, forCellWithReuseIdentifier: ElementsToursCollectionViewCell.identifier)
        collection.backgroundColor = .systemBackground
        return collection
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(collectionView)
        contentView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }
    // MARK: - CollectionView
    func configure(with viewModel : CollectionViewCellViewModel){
        self.viewModels = viewModel.viewModels
        collectionView.reloadData()
    }
    
}
extension OthersAudioToursTableViewCell : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModels.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ElementsToursCollectionViewCell.identifier, for: indexPath) as? ElementsToursCollectionViewCell else{
            fatalError()
        }
        cell.configure(with: viewModels[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 132 , height: 126)
    }
    
    
}
