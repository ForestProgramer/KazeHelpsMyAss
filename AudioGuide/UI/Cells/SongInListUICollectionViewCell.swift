//
//  SongInListUICollectionViewCell.swift
//  AudioGuide
//
//  Created by Максим Оліярник on 12.04.2024.
//

import UIKit

protocol PlayStopAudioOverAll: AnyObject{
    func didStopOrPlayAudioFromCell(isAudioPlaying: Bool, at indexPath: IndexPath)
}
class SongInListUICollectionViewCell: UICollectionViewCell {
    static let identifier : String = "SongInListUICollectionViewCell"
    weak var delegatePlayAudio : PlayStopAudioOverAll?
    var indexPath: IndexPath?
    let locationAudioImage : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "tourImage")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    let nameLocationAudio : UILabel = {
        let label = UILabel()
        label.text = "M.Zankovetska Theatre"
        label.textAlignment = .left
        label.font = .PoppinsFont(ofSize: 14, weight: .medium)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let typeAudioLabel : UILabel = {
        let label = UILabel()
        label.text = "Audio guide"
        label.textAlignment = .left
        label.font = .PoppinsFont(ofSize: 14, weight: .regular)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let likeAudioBtn : UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "likeAudioImage"), for: .normal)
        btn.backgroundColor = .clear
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        return btn
    }()
    public let stopPlayBtn : UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "playAudioImage"), for: .normal)
        btn.backgroundColor = .clear
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(playStopAudio), for: .touchUpInside)
        return btn
    }()
//    let downLoadAudioBtn : UIButton = {
//        let btn = UIButton(type: .custom)
//        btn.setImage(UIImage(named: "downLoadAudioImage"), for: .normal)
//        btn.backgroundColor = .clear
//        btn.translatesAutoresizingMaskIntoConstraints = false
//        return btn
//    }()
    var isAudioPlaying : Bool = false
    var isAudioLiked : Bool = false
    var cellHorizontalStackView : UIStackView!
    var informationHorizontalStackView : UIStackView!
    var verticalStackView : UIStackView!
    var btnsHorizontalStackView : UIStackView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        setUpCellConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setUpCellConstraints(){
        verticalStackView = UIStackView(arrangedSubviews: [nameLocationAudio,typeAudioLabel])
        verticalStackView.axis = .vertical
        verticalStackView.alignment = .fill
        verticalStackView.distribution = .equalSpacing
        verticalStackView.spacing = 0
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        
        informationHorizontalStackView = UIStackView(arrangedSubviews: [locationAudioImage,verticalStackView])
        informationHorizontalStackView.axis = .horizontal
        informationHorizontalStackView.alignment = .fill
        informationHorizontalStackView.distribution = .equalSpacing
        informationHorizontalStackView.spacing = 8
        informationHorizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        
        
        btnsHorizontalStackView = UIStackView(arrangedSubviews: [likeAudioBtn,stopPlayBtn])
        btnsHorizontalStackView.axis = .horizontal
        btnsHorizontalStackView.alignment = .fill
        btnsHorizontalStackView.distribution = .equalSpacing
        btnsHorizontalStackView.spacing = 16
        btnsHorizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        
        cellHorizontalStackView =  UIStackView(arrangedSubviews: [informationHorizontalStackView,btnsHorizontalStackView])
        cellHorizontalStackView.axis = .horizontal
        cellHorizontalStackView.alignment = .fill
        cellHorizontalStackView.distribution = .equalSpacing
        cellHorizontalStackView.spacing = 33
        cellHorizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(cellHorizontalStackView)
        
        NSLayoutConstraint.activate([
            cellHorizontalStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            cellHorizontalStackView.topAnchor.constraint(equalTo: topAnchor),
            cellHorizontalStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            cellHorizontalStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            informationHorizontalStackView.heightAnchor.constraint(equalToConstant: 55),
            
            locationAudioImage.heightAnchor.constraint(equalToConstant: 55),
            locationAudioImage.widthAnchor.constraint(equalToConstant: 55),
            
            likeAudioBtn.heightAnchor.constraint(equalToConstant: 24),
            likeAudioBtn.widthAnchor.constraint(equalToConstant: 24),
            
            stopPlayBtn.heightAnchor.constraint(equalToConstant: 24),
            stopPlayBtn.widthAnchor.constraint(equalToConstant: 24),
            
//            downLoadAudioBtn.heightAnchor.constraint(equalToConstant: 24),
//            downLoadAudioBtn.widthAnchor.constraint(equalToConstant: 24),
        ])
    }
    @objc func likeButtonTapped() {
        if isAudioLiked {
            // Видалити аудіо з улюбленого
            likeAudioBtn.setImage(UIImage(named: "likeAudioImage"), for: .normal)
            // Виконати код для видалення аудіо з улюбленого
            // Наприклад, ви можете видалити аудіо зі списку улюблених
//            removeFromFavorites()
            isAudioLiked = false
        } else {
            // Додати аудіо в улюблене
            likeAudioBtn.setImage(UIImage(named: "filledHeart"), for: .normal)
            // Виконати код для додавання аудіо в улюблене
            // Наприклад, ви можете додати аудіо до списку улюблених
//            addToFavorites()
            isAudioLiked = true
        }
    }
    @objc func playStopAudio(){
        guard let indexPath = indexPath else { return }
        if isAudioPlaying {
            stopPlayBtn.setImage(UIImage(named: "playAudioImage"), for: .normal)
            isAudioPlaying = false
            delegatePlayAudio?.didStopOrPlayAudioFromCell(isAudioPlaying: isAudioPlaying, at: indexPath)
        } else {
            stopPlayBtn.setImage(UIImage(named: "stopPlayAudioImage"), for: .normal)
            isAudioPlaying = true
            delegatePlayAudio?.didStopOrPlayAudioFromCell(isAudioPlaying: isAudioPlaying, at: indexPath)
        }
    }
    public func configureCell(with audio: OneTourAudio, indexPath: IndexPath) {
        self.indexPath = indexPath // Assign the index path
//        locationAudioImage.image = audio.imageName
//        nameLocationAudio.text = audio.name
//        typeAudioLabel.text = audio.typeGuideAudio
    }
}
