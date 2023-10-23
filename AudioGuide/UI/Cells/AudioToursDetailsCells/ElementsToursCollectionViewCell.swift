//
//  ElementsToursCollectionViewCell.swift
//  AudioGuide
//
//  Created by Максим Оліярник on 14.10.2023.
//

import UIKit
struct ElemntsColleViewCellViewModel {
    let imageName : String
}
class ElementsToursCollectionViewCell: UICollectionViewCell {
    static let identifier = "ElementsToursCollectionViewCell"
    private let imageView : UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.layer.cornerRadius = image.bounds.size.height / 4
        return image
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = contentView.bounds
    }
    func configure(with viewModel : ElemntsColleViewCellViewModel){
        imageView.image = UIImage(named: viewModel.imageName)
    }
    
}
