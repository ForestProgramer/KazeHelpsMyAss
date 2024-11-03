//
//  ControllerUIView.swift
//  AudioGuide
//
//  Created by Максим Оліярник on 10.04.2024.
//

import UIKit

class ControllerUIView: UIView {
    let nameAudioLabel : UILabel = {
        let label = UILabel()
        label.text = "M.Zankovetska Theatre"
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = .PoppinsFont(ofSize: 13, weight: .regular)
        return label
    }()
    let backAudioBtn : UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(systemName: "backward.end.alt.fill"), for: .normal)
        btn.backgroundColor = .clear
        btn.tintColor = .black
        btn.alpha = 0.5
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    let playAudioBtn : UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "stopPlayAudioImage"), for: .normal)
        btn.backgroundColor = .clear
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    let nextAudioBtn : UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "nextAudioImage"), for: .normal)
        btn.backgroundColor = .clear
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    let locatinAudioImage : UIImageView = {
        let image = UIImageView(image: UIImage(named: "tourImage"))
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    let sliderAudio : UISlider = {
        let slider = UISlider()
        slider.tintColor = UIColor(hexString: "#3D3E42")
        slider.thumbTintColor = UIColor(hexString: "#3D3E42")
        let thumbImageNormal = UIImage(named: "customThubnailImage")
        slider.setThumbImage(thumbImageNormal, for: .normal)
        slider.translatesAutoresizingMaskIntoConstraints = false
        let thumbImageHighlighted = UIImage(named: "customThubnailImage")
        slider.setThumbImage(thumbImageHighlighted, for: .highlighted)
        return slider
    }()
    let currentTimeLabel : UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .PoppinsFont(ofSize: 13, weight: .regular)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    let totalAudioTimeLabel : UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .PoppinsFont(ofSize: 13, weight: .regular)
        label.textColor = .black
        label.textAlignment = .right
        return label
    }()
    
//    let downloadAudioBtn : UIButton = {
//        let btn = UIButton(type: .custom)
//        btn.setImage(UIImage(named: "downLoadAudioImage"), for: .normal)
//        btn.backgroundColor = .clear
//        btn.translatesAutoresizingMaskIntoConstraints = false
//        return btn
//    }()
    let infinityRepeatAudioBtn : UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "repeatAudioImage"), for: .normal)
        btn.backgroundColor = .clear
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    let shuffleAudiosPlayList : UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "shuffleAudioImage"), for: .normal)
        btn.backgroundColor = .clear
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    let showPlayListBtn : UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "showPlayListImage"), for: .normal)
        btn.backgroundColor = .clear
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    var horizontalStackView : UIStackView!
    var verticalStackView : UIStackView!
    let timeContainerView : UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let sliderContainerView : UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let stopPlayContainerView : UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setUpConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        locatinAudioImage.clipsToBounds = true
    }
    private func setUpConstraints(){
        horizontalStackView = UIStackView(arrangedSubviews: [infinityRepeatAudioBtn,shuffleAudiosPlayList,showPlayListBtn])
        horizontalStackView.distribution = .equalSpacing
        horizontalStackView.spacing = 73.63
        horizontalStackView.alignment = .center
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        horizontalStackView.axis = .horizontal
//        horizontalStackView.backgroundColor = .red
        
        verticalStackView = UIStackView(arrangedSubviews: [stopPlayContainerView,sliderContainerView,timeContainerView,horizontalStackView])
        verticalStackView.distribution = .equalSpacing
        verticalStackView.spacing = .zero
        verticalStackView.alignment = .fill
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        verticalStackView.axis = .vertical
//        verticalStackView.backgroundColor = .cyan
        
        addSubview(verticalStackView)
        
        stopPlayContainerView.addSubview(nameAudioLabel)
        stopPlayContainerView.addSubview(backAudioBtn)
        stopPlayContainerView.addSubview(playAudioBtn)
        stopPlayContainerView.addSubview(nextAudioBtn)
        sliderContainerView.addSubview(sliderAudio)
        stopPlayContainerView.addSubview(locatinAudioImage)
        timeContainerView.addSubview(currentTimeLabel)
        timeContainerView.addSubview(totalAudioTimeLabel)
        
        
        NSLayoutConstraint.activate([
            verticalStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            verticalStackView.topAnchor.constraint(equalTo: topAnchor),
            verticalStackView.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -16),
            verticalStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            
            stopPlayContainerView.widthAnchor.constraint(equalToConstant: self.frame.size.width),
            stopPlayContainerView.heightAnchor.constraint(equalToConstant: 90),
            
            nameAudioLabel.leadingAnchor.constraint(equalTo: stopPlayContainerView.leadingAnchor, constant: 0),
            nameAudioLabel.topAnchor.constraint(equalTo: stopPlayContainerView.topAnchor, constant: 34),
            nameAudioLabel.widthAnchor.constraint(equalToConstant: 100),
            
            backAudioBtn.heightAnchor.constraint(equalToConstant: 24),
            backAudioBtn.widthAnchor.constraint(equalToConstant: 24),
            backAudioBtn.centerXAnchor.constraint(equalTo: stopPlayContainerView.centerXAnchor,constant: -60),
            backAudioBtn.topAnchor.constraint(equalTo: stopPlayContainerView.topAnchor, constant: 43),
            
            playAudioBtn.centerXAnchor.constraint(equalTo: stopPlayContainerView.centerXAnchor),
            playAudioBtn.topAnchor.constraint(equalTo: stopPlayContainerView.topAnchor,constant: 41),
            playAudioBtn.heightAnchor.constraint(equalToConstant: 24),
            playAudioBtn.widthAnchor.constraint(equalToConstant: 24),
            
            nextAudioBtn.heightAnchor.constraint(equalToConstant: 24),
            nextAudioBtn.widthAnchor.constraint(equalToConstant: 24),
            nextAudioBtn.centerXAnchor.constraint(equalTo: stopPlayContainerView.centerXAnchor,constant: 60),
            nextAudioBtn.topAnchor.constraint(equalTo: stopPlayContainerView.topAnchor, constant: 43),
            
            locatinAudioImage.heightAnchor.constraint(equalToConstant: 55),
            locatinAudioImage.widthAnchor.constraint(equalToConstant: 55),
            locatinAudioImage.trailingAnchor.constraint(equalTo: stopPlayContainerView.trailingAnchor,constant: 0),
            locatinAudioImage.topAnchor.constraint(equalTo: stopPlayContainerView.topAnchor,constant: 18),
            
            sliderContainerView.widthAnchor.constraint(equalToConstant: self.frame.size.width - 56),
            sliderContainerView.heightAnchor.constraint(equalToConstant: 30),
            
            sliderAudio.leadingAnchor.constraint(equalTo: sliderContainerView.leadingAnchor,constant: 12),
            sliderAudio.trailingAnchor.constraint(equalTo: sliderContainerView.trailingAnchor,constant: -12),
            sliderAudio.centerYAnchor.constraint(equalTo: sliderContainerView.centerYAnchor),
            sliderAudio.centerXAnchor.constraint(equalTo: sliderContainerView.centerXAnchor),
            sliderAudio.heightAnchor.constraint(equalToConstant: 14),
            
            timeContainerView.widthAnchor.constraint(equalToConstant: self.frame.size.width - 56),
            timeContainerView.heightAnchor.constraint(equalToConstant: 25),
            
            currentTimeLabel.leadingAnchor.constraint(equalTo: timeContainerView.leadingAnchor, constant: 12),
            currentTimeLabel.trailingAnchor.constraint(equalTo: timeContainerView.centerXAnchor),
            currentTimeLabel.centerYAnchor.constraint(equalTo: timeContainerView.centerYAnchor),
            
            totalAudioTimeLabel.trailingAnchor.constraint(equalTo: timeContainerView.trailingAnchor,constant: -12),
            totalAudioTimeLabel.centerYAnchor.constraint(equalTo: timeContainerView.centerYAnchor),
        
            horizontalStackView.widthAnchor.constraint(equalToConstant: self.frame.size.width - 56),
            horizontalStackView.heightAnchor.constraint(equalToConstant: 26)
            
            
        ])
        locatinAudioImage.layer.cornerRadius = 27.5
    }
}
