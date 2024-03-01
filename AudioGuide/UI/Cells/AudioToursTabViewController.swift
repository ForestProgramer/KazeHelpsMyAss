//
//  AudioToursTabViewController.swift
//  AudioGuide
//
//  Created by Максим Оліярник on 28.12.2023.
//
//AUDIO TOURS TAB

import UIKit
import SkeletonView
import InstantSearchVoiceOverlay
class AudioToursTabViewController: AGViewController {
    
    private let apiCall = APIManager.shared
//    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var audiToursCollectionView: UICollectionView!
    @IBOutlet weak var voiceSearchBtn: UIButton!
    private var allGuides: [AudioTour] = [AudioTour(name: "", duration: "", distance: "", price: "", photoName: ""),AudioTour(name: "", duration: "", distance: "", price: "", photoName: ""),AudioTour(name: "", duration: "", distance: "", price: "", photoName: "")]
    private var filteredGuides: [AudioTour] = [AudioTour(name: "", duration: "", distance: "", price: "", photoName: ""),AudioTour(name: "", duration: "", distance: "", price: "", photoName: ""),AudioTour(name: "", duration: "", distance: "", price: "", photoName: "")]
    private var isSearching: Bool {
        return !searchField.text!.isEmpty
    }
    private let voiceOverlay = VoiceOverlayController()
    private let viewNoLabel = UIView()
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        self.cancelsEditingByBackgroundTap = true
        setUpGuideCollectionView()
        voiceSearchBtn.addTarget(self, action: #selector(didTapVoiceSearch), for: .touchUpInside)
        searchField.delegate = self
        setUpNoResultView()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.setUpSkelletonView()
        }

        guard let idDevice = UserDefaults.standard.value(forKey: "id_device") as? String else{
            return
        }
        apiCall.getTours(idDevice: idDevice,with: 1) {[weak self] result in
            guard let strongSelf = self else{
                return
            }
            switch result{
            case .success(let tourModel):
                let tours = tourModel.data.prefix(6)
                var allTours = [AudioTour]()
                for (_,tour) in tours.enumerated(){
                    let name = tour.toursLangData.first?.name ?? "Unknown"
                    let duration = tour.duration
                    let distance = tour.distance
                    let price = tour.rating
                    let img = tour.img
                    let audioTour = AudioTour(name: name, duration: duration, distance: distance, price: "\(price)", photoName: "https://buffer.com/cdn-cgi/image/w=1000,fit=contain,q=90,f=auto/library/content/images/size/w1200/2023/09/instagram-image-size.jpg")
                    allTours.append(audioTour)
                }
                
                DispatchQueue.main.async {
                    strongSelf.allGuides = allTours
                    strongSelf.audiToursCollectionView.stopSkeletonAnimation()
                    strongSelf.audiToursCollectionView.hideSkeleton()
                    strongSelf.audiToursCollectionView.reloadData()
                }
                
            case .failure(let error):
                print("Tour get error : \(String(describing: error))")
            }
        }
    }
    @objc private func didTapVoiceSearch(){
        voiceOverlay.start(on: self, textHandler: {text , final, _ in
            if final{
                DispatchQueue.main.async {
                    self.searchField.text = text // Присвоюємо текст поля пошуку
                    self.checkSearchField() // Викликаємо функцію для перевірки тексту у полі пошуку
                }
            }
        }, errorHandler: {error in
            
        }, resultScreenHandler: nil)
    }
    private func checkSearchField() {
        guard let searchText = searchField.text?.lowercased(), !searchText.isEmpty else {
            DispatchQueue.main.async {
                self.audiToursCollectionView.stopSkeletonAnimation()
                self.audiToursCollectionView.hideSkeleton()
                self.audiToursCollectionView.reloadData()
            }
            return
        }
        DispatchQueue.main.async {
            self.setUpSkelletonView()
            self.filterLocations(with: searchText)
        }
    }
    private func setUpSkelletonView(){
        audiToursCollectionView.isSkeletonable = true
        audiToursCollectionView.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .systemGray3, secondaryColor: .systemGray6), animation: nil, transition: .crossDissolve(0.25))
    }
    private func setUpGuideCollectionView(){
        self.audiToursCollectionView.dataSource = self
        self.audiToursCollectionView.delegate = self
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        let procentsHeight = 0.452
        let totalWidth = screenWidth - 32
        let totalHeight = screenHeight * procentsHeight
        layout.itemSize = CGSize(width: totalWidth, height: totalHeight)
        audiToursCollectionView.collectionViewLayout = layout
    }
    private func setUpNoResultView() {
        viewNoLabel.backgroundColor = UIColor(hexString: "#fafafa")
        viewNoLabel.translatesAutoresizingMaskIntoConstraints = false
        viewNoLabel.accessibilityIdentifier = "noResultView"
        viewNoLabel.isHidden = true
        viewNoLabel.alpha = 0
        let noresultsImageView : UIImageView = {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            imageView.image = UIImage(named: "noResultsImage")
            imageView.translatesAutoresizingMaskIntoConstraints = false
            return imageView
        }()
        let noResultsLabel = UILabel()
        noResultsLabel.text = "No result was found"
        noResultsLabel.textAlignment = .center
        noResultsLabel.textColor = .label
        noResultsLabel.font = .PoppinsFont(ofSize: 18, weight: .semibold)
        noResultsLabel.translatesAutoresizingMaskIntoConstraints = false
        let noResultsDescLabel = UILabel()
        noResultsDescLabel.text = "Please check the spelling or try another variant."
        noResultsDescLabel.textAlignment = .center
        noResultsDescLabel.textColor = .black
        noResultsDescLabel.font = .PoppinsFont(ofSize: 15, weight: .light)
        noResultsDescLabel.numberOfLines = 2
        noResultsDescLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(viewNoLabel)
        viewNoLabel.addSubview(noResultsLabel)
        viewNoLabel.addSubview(noresultsImageView)
        viewNoLabel.addSubview(noResultsDescLabel)
        
        NSLayoutConstraint.activate([
            viewNoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            viewNoLabel.topAnchor.constraint(equalTo: searchView.bottomAnchor),
            viewNoLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            viewNoLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            noresultsImageView.leadingAnchor.constraint(equalTo: viewNoLabel.leadingAnchor),
            noresultsImageView.topAnchor.constraint(equalTo: viewNoLabel.topAnchor,constant: 64),
            noresultsImageView.trailingAnchor.constraint(equalTo: viewNoLabel.trailingAnchor),
            noresultsImageView.bottomAnchor.constraint(equalTo: noResultsLabel.topAnchor, constant : -16),
                    
            noResultsLabel.centerXAnchor.constraint(equalTo: viewNoLabel.centerXAnchor),
            noResultsLabel.topAnchor.constraint(equalTo: noresultsImageView.bottomAnchor,constant: 16),
            
            noResultsDescLabel.centerXAnchor.constraint(equalTo: viewNoLabel.centerXAnchor),
            noResultsDescLabel.topAnchor.constraint(equalTo: noResultsLabel.bottomAnchor),
            noResultsDescLabel.widthAnchor.constraint(equalToConstant: 226)
        ])
    }
    @available(iOSApplicationExtension, unavailable)
    private func setup() {
//        self.scrollView.addSubview(self.mainView)
        //        self.searchField.clearButtonTintColor = UIColor(named: "AccentColor")
        self.view.addSubview(mainView)
        mainView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            mainView.topAnchor.constraint(equalTo: self.view.topAnchor,constant: self.safeAreaTopHeight + CGFloat(CustomNavigationController.customNavigationBarHeight)),
            mainView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            mainView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        self.searchField.attributedPlaceholder = NSAttributedString(string: "Search", attributes: [NSAttributedString.Key.foregroundColor: (UIColor(hexString: "#3C3C43").withAlphaComponent(0.6)), NSAttributedString.Key.font: UIFont.PoppinsFont(ofSize: 14)])
        self.audiToursCollectionView.delegate = self
        self.audiToursCollectionView.dataSource = self
    }
    @available(iOSApplicationExtension, unavailable)
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    
}
extension AudioToursTabViewController : SkeletonCollectionViewDataSource {
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "AudioTourCollectionViewCell"
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let searchText = self.searchField.text, !searchText.isEmpty {
            return filteredGuides.count
        } else {
            return allGuides.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AudioTourCollectionViewCell", for: indexPath) as? AudioTourCollectionViewCell else{
            fatalError()
            
        }
        let guide : AudioTour
        if let searchText = self.searchField.text, !searchText.isEmpty {
            // Якщо текстове поле не порожнє, використовуйте відфільтрований масив локацій
            guide = filteredGuides[indexPath.row]
        } else {
            // Якщо текстове поле порожнє, використовуйте звичайний масив локацій
            guide = allGuides[indexPath.row]
        }
        cell.setup(with: guide)
        return cell
    }
}
// MARK: - UICollectionViewDelegate methods

extension AudioToursTabViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         if collectionView == self.audiToursCollectionView{
            self.showAudioDetails()
         }
        
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension AudioToursTabViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        let procentsHeight = 0.452
        let totalWidth = screenWidth - 32
        let totalHeight = screenHeight * procentsHeight
        return CGSize(width: totalWidth, height: totalHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
        
    }
}
extension AudioToursTabViewController : UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // Приховує клавіатуру
        return true
    }
    
    // Коли текст у текстовому полі змінюється
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if let text = textField.text, !text.isEmpty{
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.3) {
                    self.viewNoLabel.alpha = 0
                }completion: { _ in
                    self.viewNoLabel.isHidden = true
                }
                self.setUPSearchSkelleton()
            }
           
        }else{
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.3) {
                    self.viewNoLabel.alpha = 0
                }completion: { _ in
                    self.viewNoLabel.isHidden = true
                }
                self.audiToursCollectionView.stopSkeletonAnimation()
                self.audiToursCollectionView.hideSkeleton()
                self.audiToursCollectionView.reloadData()
            }
        }
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        filterLocations(with: textField.text)
        return true
    }
    func setUPSearchSkelleton(){
        audiToursCollectionView.isSkeletonable = true
        audiToursCollectionView.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .systemGray3, secondaryColor: .systemGray6), animation: nil, transition: .crossDissolve(0.25))
    }
    // Функція фільтрації локацій
    func filterLocations(with searchText: String?) {
        guard let idDevice = UserDefaults.standard.value(forKey: "id_device") as? String, let searchText = searchText?.lowercased(), !searchText.isEmpty else {
            // Якщо текстове поле порожнє, очистіть масив відфільтрованих локацій
            filteredGuides = [AudioTour(name: "", duration: "", distance: "", price: "", photoName: ""),AudioTour(name: "", duration: "", distance: "", price: "", photoName: ""),AudioTour(name: "", duration: "", distance: "", price: "", photoName: "")]
            audiToursCollectionView.reloadData() // Оновіть колекційне представлення
            return
        }
        self.apiCall.getSearchResults(idDevice: idDevice, keywords: searchText, orderBy: .id, sort: .desc, typeFilter: .tours, mode: .toursInPoints, responseType: SearchTourData.self) { [weak self](result: Result<SearchTourData, Error>)  in
            guard let strongSelf = self else{
                return
            }
            switch result {
            case .success(let searchResults):
                let data = searchResults.data
                var allTours = [AudioTour]()
                for (_,tour) in data.enumerated(){
                    let name = tour.toursLangData.first?.name ?? "Unknown"
                    let duration = tour.duration
                    let distance = tour.distance
                    let price = tour.rating
                    let img = tour.img
                    let audioTour = AudioTour(name: name, duration: duration, distance: distance, price: "\(price)", photoName: "https://buffer.com/cdn-cgi/image/w=1000,fit=contain,q=90,f=auto/library/content/images/size/w1200/2023/09/instagram-image-size.jpg")
                    allTours.append(audioTour)
                }
               
                DispatchQueue.main.async {
                    strongSelf.filteredGuides = allTours
                    strongSelf.audiToursCollectionView.stopSkeletonAnimation()
                    strongSelf.audiToursCollectionView.hideSkeleton()
                    strongSelf.audiToursCollectionView.reloadData()
                }
            case .failure(let error):
                print("Error fetching search results: \(error)")
                DispatchQueue.main.async {
                    strongSelf.audiToursCollectionView.stopSkeletonAnimation()
                    strongSelf.audiToursCollectionView.hideSkeleton()
                    strongSelf.viewNoLabel.isHidden = false
                    UIView.animate(withDuration: 0.3) {
                        strongSelf.viewNoLabel.alpha = 1
                    }
                   
                }
            }
        }
    }
}
