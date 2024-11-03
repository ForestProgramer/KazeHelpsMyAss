//
//  PlayerAudioViewController.swift
//  AudioGuide
//
//  Created by Максим Оліярник on 08.04.2024.
//
import UIKit
import AVFoundation
enum DiagnoseViewTypes {
    case half
    case full
}
protocol DidHideAudioPlaylist{
    func movePanelTo(position : DiagnoseViewTypes)
}
class PlayerAudioViewController: UIViewController {
    public var delegate : DidHideAudioPlaylist!
    var toggleStateHandler: (() -> Void)?
    public var audioPosition : Int = 0
    public var audios : [OneTourAudio]? = []
    public let audioControllerContainer : ControllerUIView = {
        let view = ControllerUIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    public let audioCollectionViewListContainer : PlayListUIView = {
        let view = PlayListUIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    var player: AVPlayer?
    var playerItem: AVPlayerItem?
    var timer: Any?
    private(set) var isLooping : Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        setUpPlayerControllers()
        setUpCollectionViewDelegate()
        setUpBackBtn()
        setUpExpandOrHideBtn()
        // Add observer for track end
        NotificationCenter.default.addObserver(self, selector: #selector(audioDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }
    @objc private func audioDidFinishPlaying() {
        guard let audios = self.audios else {
            return
        }
        
        if audioPosition < audios.count - 1 {
            // Move to the next track
            updatePlayPauseButtonInCell(at: audioPosition, isPlaying: false)
            audioPosition += 1
            updateButtonStates()
            reloadPlayerForCurrentTrack()
            updatePlayPauseButtonInCell(at: audioPosition, isPlaying: true)
        } else {
            // If it's the last track, stop updating and reset the UI
            stopUpdatingSlider()
            updatePlayPauseButtonInCell(at: audioPosition, isPlaying: false)
            audioControllerContainer.playAudioBtn.setImage(UIImage(named: "playAudioImage"), for: .normal)
        }
    }
    private func startUpdatingSlider() {
        timer = player?.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 1), queue: .main) { [weak self] time in
            self?.updateSlider()
        }
    }
    @objc private func updateSlider() {
        guard let player = player else { return }
        let currentTime = CMTimeGetSeconds(player.currentTime())
        let duration = CMTimeGetSeconds(player.currentItem?.duration ?? CMTime.zero)
        
        audioControllerContainer.currentTimeLabel.text = DateComponentsFormatter.positional.string(from: currentTime)
        audioControllerContainer.totalAudioTimeLabel.text = DateComponentsFormatter.positional.string(from: duration - currentTime)
        audioControllerContainer.sliderAudio.value = Float(currentTime)
        audioControllerContainer.sliderAudio.maximumValue = Float(duration)
    }
    private func stopUpdatingSlider() {
        if let timer = timer {
            player?.removeTimeObserver(timer)
            self.timer = nil
        }
    }
//    private func toogleLoop(){
//        guard let player = player else{return}
//        player.numberOfLoops = player.numberOfLoops == 0 ? -1 : 0
//        isLooping = player.numberOfLoops != 0
//    }
    private func setUpCollectionViewDelegate(){
        audioCollectionViewListContainer.registerCollectionViewCell(with: SongInListUICollectionViewCell.self, and: SongInListUICollectionViewCell.identifier)
        audioCollectionViewListContainer.delegateCollectionView(withController: self)
        audioCollectionViewListContainer.dataSourceCollectionView(withController: self)
    }
    private func setUpBackBtn(){
        audioCollectionViewListContainer.backBtn.addTarget(self, action: #selector(delegateBackBtn), for: .touchUpInside)
    }
    private func setUpPlayerControllers(){
        setUpSlider()
        audioControllerContainer.playAudioBtn.addTarget(self, action: #selector(didTapPausePlayBtn), for: .touchUpInside)
        audioControllerContainer.backAudioBtn.addTarget(self, action: #selector(didTapBackBtn), for: .touchUpInside)
        audioControllerContainer.nextAudioBtn.addTarget(self, action: #selector(didTapNextBtn), for: .touchUpInside)
    }
    @objc private func didTapPausePlayBtn() {
            if player?.timeControlStatus == .playing {
                player?.pause()
                stopUpdatingSlider()
                UIView.animate(withDuration: 0.3) {
                    self.audioControllerContainer.playAudioBtn.setImage(UIImage(named: "playAudioImage"), for: .normal)
                    self.updatePlayPauseButtonInCell(at: self.audioPosition, isPlaying: false)
                }
            } else {
                player?.play()
                startUpdatingSlider()
                UIView.animate(withDuration: 0.3) {
                    self.audioControllerContainer.playAudioBtn.setImage(UIImage(named: "stopPlayAudioImage"), for: .normal)
                    self.updatePlayPauseButtonInCell(at: self.audioPosition, isPlaying: true)
                }
            }
        }
    private func updatePlayPauseButtonInCell(at index: Int, isPlaying: Bool) {
        let indexPath = IndexPath(row: index, section: 0)
        if let cell = audioCollectionViewListContainer.listAudioCollectionView.cellForItem(at: indexPath) as? SongInListUICollectionViewCell {
            let playPauseImage = isPlaying ? UIImage(named: "stopPlayAudioImage") : UIImage(named: "playAudioImage")
            cell.stopPlayBtn.setImage(playPauseImage, for: .normal)
        }
    }
    @objc private func didTapBackBtn() {
        if audioPosition > 0 {
            updatePlayPauseButtonInCell(at: audioPosition, isPlaying: false)
            audioPosition -= 1
            updateButtonStates()
            stopUpdatingSlider()
            reloadPlayerForCurrentTrack()
            updatePlayPauseButtonInCell(at: audioPosition, isPlaying: true)
        }
    }
    @objc private func didTapNextBtn() {
        guard let audios = self.audios else{
            return
        }
        if audioPosition < (audios.count - 1) {
            updatePlayPauseButtonInCell(at: audioPosition, isPlaying: false)
            audioPosition += 1
            updateButtonStates()
            stopUpdatingSlider()
            reloadPlayerForCurrentTrack()
            updatePlayPauseButtonInCell(at: audioPosition, isPlaying: true)
        }
    }
    private func updateButtonStates() {
        guard let audios = self.audios else{
            return
        }
        audioControllerContainer.backAudioBtn.alpha = audioPosition == 0 ? 0.5 : 1
        audioControllerContainer.nextAudioBtn.alpha = audioPosition == (audios.count - 1) ? 0.5 : 1
    }
       
    private func reloadPlayerForCurrentTrack() {
        for subview in view.subviews {
            subview.removeFromSuperview()
        }
        setUpContraints()
        configure()
    }
    private func setUpExpandOrHideBtn(){
        audioControllerContainer.showPlayListBtn.addTarget(self, action: #selector(didShowOrHidePlaylist), for: .touchUpInside)
        audioControllerContainer.infinityRepeatAudioBtn.addTarget(self, action: #selector(didRepetAudio), for: .touchUpInside)
    }
    @objc private func didRepetAudio() {
        guard let player = player else { return }
        isLooping.toggle()
        if isLooping {
            NotificationCenter.default.addObserver(self, selector: #selector(loopAudio), name: .AVPlayerItemDidPlayToEndTime, object: player.currentItem)
        } else {
            NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: player.currentItem)
        }
        audioControllerContainer.infinityRepeatAudioBtn.setImage(isLooping ? UIImage(named: "filledRepeatAudioImage") : UIImage(named: "repeatAudioImage"), for: .normal)
    }
    @objc private func loopAudio() {
        player?.seek(to: .zero)
        player?.play()
    }
    @objc private func didShowOrHidePlaylist(){
        toggleStateHandler?()
    }
    @objc private func delegateShowPlaylistBtn(){
        if let delegate = delegate{
            delegate.movePanelTo(position: .full)
        }
    }
    @objc private func delegateBackBtn(){
        if let delegate = delegate{
            delegate.movePanelTo(position: .half)
        }
    }
    private func setUpSlider(){
        audioControllerContainer.sliderAudio.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .touchUpInside)
    }
    @objc func sliderValueChanged(_ slider: UISlider) {
        guard let player = player else { return }
        let timeInSeconds = CMTimeMake(value: Int64(slider.value), timescale: 1)
        player.seek(to: timeInSeconds)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if view.subviews.count == 0{
            setUpContraints()
            print(audios?.count)
            configure()
        }
        
    }
    func configure() {
        guard let audio = audios?[audioPosition], let url = URL(string: audio.audioURL) else {
                print("Invalid URL")
                return
            }
            print("Audio Present\(audio)")
            playerItem = AVPlayerItem(url: url)
            player = AVPlayer(playerItem: playerItem)
            
            guard let player = player else { return }
            
            player.play()
            startUpdatingSlider()
            
            // Update UI
//            audioControllerContainer.locatinAudioImage.image = audio.imageName
//            audioControllerContainer.nameAudioLabel.text = audio.name
            audioControllerContainer.playAudioBtn.setImage(UIImage(named: "stopPlayAudioImage"), for: .normal)
        }
    private func setUpContraints(){
        let verticalStackView = UIStackView(arrangedSubviews: [audioCollectionViewListContainer])
        verticalStackView.axis = .vertical
        verticalStackView.distribution = .equalSpacing
        verticalStackView.spacing = 0
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        verticalStackView.backgroundColor = .clear
        let controllerHeight = UIScreen.main.bounds.size.height * 0.2257
        view.addSubview(verticalStackView)
        view.addSubview(audioControllerContainer)
        NSLayoutConstraint.activate([
            audioControllerContainer.heightAnchor.constraint(equalToConstant: controllerHeight),
            audioControllerContainer.widthAnchor.constraint(equalToConstant: view.frame.size.width),
            audioControllerContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -82),
            
            verticalStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            verticalStackView.topAnchor.constraint(equalTo: view.topAnchor),
            verticalStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            verticalStackView.bottomAnchor.constraint(equalTo: audioControllerContainer.topAnchor),
            
            audioCollectionViewListContainer.widthAnchor.constraint(equalToConstant: view.frame.size.width),
            
        ])
    }
    func updateView(viewType: DiagnoseViewTypes) {
        UIView.animate(withDuration: 0.2, delay: 0.1, options: .curveEaseInOut) {
            self.view.layoutIfNeeded()
            
            switch viewType {
            case .half:
                self.audioControllerContainer.isHidden = false
                self.audioCollectionViewListContainer.isHidden = true
                self.audioControllerContainer.alpha = 1
                self.audioCollectionViewListContainer.alpha = 0
                self.audioControllerContainer.showPlayListBtn.setImage(UIImage(named: "showPlayListImage"), for: .normal)
            case .full:
                self.audioControllerContainer.isHidden = false
                self.audioCollectionViewListContainer.isHidden = false
                self.audioControllerContainer.alpha = 1
                self.audioCollectionViewListContainer.alpha = 1
                self.audioControllerContainer.showPlayListBtn.setImage(UIImage(named: "showedListImage"), for: .normal)
            }
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let player = player {
            player.pause()
            stopUpdatingSlider()
        }
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }
}
extension PlayerAudioViewController : UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        audios?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SongInListUICollectionViewCell.identifier, for: indexPath) as? SongInListUICollectionViewCell else{
            fatalError()
        }
        let audio = audios?[indexPath.row] ?? OneTourAudio(id: 0, idPoint: 0, idUser: 0, audioUrl: "", audioTime: "", createdAt: "", updatedAt: "", audioURL: "", isFavorite: true)
        if indexPath.row == 0{
            cell.stopPlayBtn.setImage(UIImage(named: "stopPlayAudioImage"), for: .normal)
            cell.isAudioPlaying = true
        }
        cell.configureCell(with: audio, indexPath: indexPath)
        cell.delegatePlayAudio = self
        return cell
    }
}
extension PlayerAudioViewController : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let insets: CGFloat = 17.0
        // Висота екрана айфона помножена на 0.085
        let itemHeight = UIScreen.main.bounds.height * 0.064
        return CGSize(width: UIScreen.main.bounds.width - 2 * insets, height: itemHeight)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        10
    }
}
extension PlayerAudioViewController: PlayStopAudioOverAll {
    func didStopOrPlayAudioFromCell(isAudioPlaying: Bool, at indexPath: IndexPath) {
        // Stop the currently playing track if a new track is being played
        if isAudioPlaying {
            if audioPosition != indexPath.row {
                updatePlayPauseButtonInCell(at: audioPosition, isPlaying: false)
                player?.pause()
                stopUpdatingSlider()
                audioPosition = indexPath.row
                configure() // Configure the player for the new track
                player?.play()
                startUpdatingSlider()
                updatePlayPauseButtonInCell(at: audioPosition, isPlaying: true)
            } else {
                player?.pause()
                stopUpdatingSlider()
                UIView.animate(withDuration: 0.3) {
                    self.audioControllerContainer.playAudioBtn.setImage(UIImage(named: "playAudioImage"), for: .normal)
                }
            }
        } else {
            player?.pause()
            stopUpdatingSlider()
            UIView.animate(withDuration: 0.3) {
                self.audioControllerContainer.playAudioBtn.setImage(UIImage(named: "playAudioImage"), for: .normal)
            }
        }
    }
}

