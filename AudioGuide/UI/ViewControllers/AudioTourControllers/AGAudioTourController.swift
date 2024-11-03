//
//  AGAudioTourController.swift
//  AudioGuide
//
//  Created by Sergej Bekker on 02.02.2022.
//

import UIKit
import SkeletonView
import InstantSearchVoiceOverlay
class AGAudioTourController: AGViewController {
    private let apiCall = APIManager.shared
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet private weak var mainView: UIView!
    @IBOutlet weak var leadingConstrainMeetLabel: NSLayoutConstraint!
    @IBOutlet private weak var locationCollectionView: UICollectionView!
    @IBOutlet private weak var guideCollectionView: UICollectionView!
    @IBOutlet private weak var cafeCollectionView: UICollectionView!
    @IBOutlet private weak var searchField: UITextField!
    @IBOutlet weak var meetLabel: AGLabel!
    @IBOutlet weak var voiceSearchBtn: UIButton!
    private let resultsView = SearchResultsUIView()
    private let voiceOverlay = VoiceOverlayController()
    @IBOutlet weak var searchFieldView: UIView!
    private var allLocations: [Location] = []
    private var allGuides: [AudioTour] = []
        private var allCafes: [Cafe] = [Cafe(photoName: "cafe_cell_icon", rating: "5"),Cafe(photoName: "cafe_cell_icon", rating: "4"),Cafe(photoName: "cafe_cell_icon", rating: "3.8"),Cafe(photoName: "cafe_cell_icon", rating: "4"),Cafe(photoName: "cafe_cell_icon", rating: "3")]
    private var filteredLocations: [Location] = [Location(name: "", street: "", photoName: "", id: 0),Location(name: "", street: "", photoName: "", id: 0),Location(name: "", street: "", photoName: "", id: 0),Location(name: "", street: "", photoName: "", id: 0)]
    private var filteredGuides: [AudioTour] = []
//    private var filteredCafes: [Cafe] = []
    private var isSearching: Bool {
            return !searchField.text!.isEmpty
        }
    let viewNoLabel = UIView()
    private let noAccountPopUp = NoAccountPopUp()
    let searchBackBtn = UIButton(type: .custom)
    override func viewDidLoad() {
        super.viewDidLoad()
        searchField.addTarget(self, action: #selector(searchFieldDidChange(_:)), for: .editingChanged)
        searchField.clearButtonMode = .always
        scrollView.backgroundColor = UIColor(hexString: "#FAFAFA")
        self.setup()
        setUpLocationCollectionView()
        setUpGuideCollectionView()
        setUpBackSearchBtn()
        voiceSearchBtn.addTarget(self, action: #selector(didTapVoiceSearch), for: .touchUpInside)
        searchField.delegate = self
        setUpShowResultsView()
        setUpNoResultView()
        addNoAccountPopUp()
        
    }
    private func setUpBackSearchBtn(){
        searchBackBtn.translatesAutoresizingMaskIntoConstraints = false
        searchBackBtn.setImage(UIImage(named: "backDoorImage"), for: .normal)
        searchBackBtn.addTarget(self, action: #selector(goBackTap), for: .touchUpInside)
        searchBackBtn.isHidden = true
        mainView.addSubview(searchBackBtn)
        NSLayoutConstraint.activate([
            searchBackBtn.centerYAnchor.constraint(equalTo: meetLabel.centerYAnchor),
            searchBackBtn.leadingAnchor.constraint(equalTo: mainView.leadingAnchor,constant: 16),
            searchBackBtn.heightAnchor.constraint(equalToConstant: 32),
            searchBackBtn.widthAnchor.constraint(equalToConstant: 32),
        ])
    }
    private func addNoAccountPopUp(){
        noAccountPopUp.alpha = 0
        noAccountPopUp.tryAgainButton.addTarget(self, action: #selector(tapRegisterAccount), for: .touchUpInside)
        noAccountPopUp.isHidden = true
        if let tabBarController = self.tabBarController {
        tabBarController.view.addSubview(noAccountPopUp)
            noAccountPopUp.frame = tabBarController.view.frame
            noAccountPopUp.frame = tabBarController.view.frame
        }
    }
    @objc private func tapRegisterAccount(){
        // Анімація зникаючого ефекту
            UIView.animate(withDuration: 0.3, animations: {
                self.noAccountPopUp.alpha = 0.0
            }) { _ in
                // Приховання поп-апу після завершення анімації
                self.noAccountPopUp.isHidden = true
                // Створення контролеру реєстрації
                if let tabBarController = self.tabBarController {
                    // Створіть AGRegistrationViewController
                    if let registrationController = self.storyboard?.instantiateViewController(withIdentifier: "AGLoginViewController") as? AGLoginViewController {
                        tabBarController.addChild(registrationController)
                        tabBarController.view.addSubview(registrationController.view)
                        registrationController.didMove(toParent: tabBarController)
                        UserDefaults.isUserAuthorizationPassed = false
                        UserDefaults.isFirstLaunchPassed = false
                        UserDefaults.isFreeVersion = false
                    }
                }
            }
    }
    @objc private func goBackTap(){
        guard let searchText = self.searchField.text , !searchText.isEmpty else{
            return
        }
        if let oldConstraint = self.leadingConstrainMeetLabel {
            NSLayoutConstraint.deactivate([oldConstraint])
            self.leadingConstrainMeetLabel = self.meetLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 16)
            leadingConstrainMeetLabel?.isActive = true
        }
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3) {
                self.searchBackBtn.isHidden = true
                self.meetLabel.text = "Nice to meet you in Lviv!"
                self.searchField.text = ""
                self.searchField.resignFirstResponder()
                self.hideNoResultsLabel()
                self.resultsView.isHidden = true
                self.mainView.layoutIfNeeded()
            }
        }
    }
    @objc func searchFieldDidChange(_ textField: UITextField) {
            // Перевіряємо, чи searchField не є пустим
            if let searchText = textField.text, !searchText.isEmpty {
                
            } else {
                // Якщо пустий, приховуємо resultsView
               
                UIView.animate(withDuration: 0.3) {
                    self.resultsView.alpha = 0
                }completion: { _ in
                    self.resultsView.isHidden = true
                }
                hideNoResultsLabel()
            }
        }
    private func setUpShowResultsView(){
        resultsView.translatesAutoresizingMaskIntoConstraints = false
        resultsView.isHidden = true
        mainView.addSubview(resultsView)
        NSLayoutConstraint.activate([
            resultsView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
            resultsView.topAnchor.constraint(equalTo: searchFieldView.bottomAnchor),
            resultsView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
            resultsView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
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
            // Якщо поле пошуку не пусте, показуємо resultsView
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.3) {
                    self.resultsView.alpha = 0
                }completion: { _ in
                    self.resultsView.isHidden = true
                    
                }
                self.hideNoResultsLabel()
                self.resultsView.resultsLocationsColectionView.stopSkeletonAnimation()
                self.resultsView.resultsLocationsColectionView.hideSkeleton()
            }
            return
        }
        
        self.setUpSkelletonViews()
        self.resultsView.isHidden = false
        UIView.animate(withDuration: 0.3) {
            self.resultsView.alpha = 1
        }completion: { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.apiCallWithSearchText(searchText: searchText)
            }
        }
    }
    private func setUpSkelletonViews(){
        resultsView.resultsLocationsColectionView.isSkeletonable = true
        resultsView.resultsLocationsColectionView.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .systemGray3, secondaryColor: .systemGray6), animation: nil, transition: .crossDissolve(0.25))
        resultsView.resultsToursColectionView.isSkeletonable = true
        resultsView.resultsToursColectionView.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .systemGray3, secondaryColor: .systemGray6), animation: nil, transition: .crossDissolve(0.25))
    }
    func apiCallWithSearchText(searchText: String) {
        guard let idDevice = UserDefaults.standard.value(forKey: "id_device") as? String else{
            return
        }
        apiCall.getSearchResults(idDevice: idDevice, keywords: searchText, orderBy: .id, sort: .desc, typeFilter: .locations, mode: .toursInPoints,responseType: LocationDataDetails.self) { [weak self] (result: Result<LocationDataDetails, Error>) in
            guard let strongSelf = self else{
                return
            }
            switch result {
            case .success(let searchResults):
                let data = searchResults.data
                var tours = [AudioTour]()
                var locations = [Location]()
                for (_,point) in data.enumerated(){
                    let name = point.pointLangData.first?.name ?? "Unknown"
                    let street = point.pointLangData.first?.address ?? "Unknown"
                    let photoName = point.img
                    let locationID = point.id
                    let location = Location(name: name, street: street, photoName: "https://devapi.test.vn.ua/storage/" + photoName, id: locationID )
                    locations.append(location)
                    for (tourIndex , tour ) in point.tours.enumerated(){
                        let name = tour.toursLangData[tourIndex].name
                        let img = tour.img
                        let audioTour = AudioTour(id: tour.id, name: name, duration: tour.duration, distance: tour.distance, price: "0$", photoName: "https://devapi.test.vn.ua/storage/" + img)
                        tours.append(audioTour)
                    }
                }
               
                DispatchQueue.main.async {
                    strongSelf.filteredLocations = locations
                    strongSelf.filteredGuides = tours
                    if tours.isEmpty{
                        strongSelf.resultsView.insertToursLabel.isHidden = true
                    }else{
                        strongSelf.resultsView.insertToursLabel.isHidden = false
                    }
                    strongSelf.hideNoResultsLabel()
                    strongSelf.resultsView.isHidden = false
                    strongSelf.resultsView.resultsLocationsColectionView.stopSkeletonAnimation()
                    strongSelf.resultsView.resultsLocationsColectionView.hideSkeleton()
                    strongSelf.resultsView.resultsLocationsColectionView.reloadData()
                    strongSelf.resultsView.resultsToursColectionView.stopSkeletonAnimation()
                    strongSelf.resultsView.resultsToursColectionView.hideSkeleton()
                    strongSelf.resultsView.resultsToursColectionView.reloadData()
                }
            case .failure(let error):
                print("Error fetching search results: \(error)")
                DispatchQueue.main.async {
                    strongSelf.viewNoLabel.isHidden = false
                    UIView.animate(withDuration: 0.3) {
                        strongSelf.viewNoLabel.alpha = 1
                    }completion: { _ in
                        strongSelf.resultsView.alpha = 0
                        strongSelf.resultsView.isHidden = true
                    }
                    
                }
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let idDevice = UserDefaults.standard.value(forKey: "id_device") as? String else{
            return
        }
        if let customNavigationController = self.navigationController as? CustomNavigationController {
            // Приховуємо кастомний навігаційний бар
            customNavigationController.customNavigationBar.isHidden = false // або false для показу
        }
        apiCall.getPoints(idDevice: idDevice,with: 4) {[weak self] result in
            guard let strongSelf = self else{
                return
            }
            switch result {
            case .success(let pointModel):
                let points = pointModel.data.prefix(6)
                var locations = [Location]()
                for (_,point) in points.enumerated(){
                    let name = point.pointLangData.first?.name ?? "Unknown"
                    let street = point.pointLangData.first?.address ?? "Unknown"
                    let photoName = point.img
                    let locationID = point.id
                    let location = Location(name: name, street: street, photoName: "https://devapi.test.vn.ua/storage/" + photoName, id: locationID)
                    locations.append(location)
                }
                DispatchQueue.main.async {
                    strongSelf.allLocations = locations
                    strongSelf.locationCollectionView.reloadData()
                }
            case .failure(let error):
                print("Point get error : \(String(describing: error))")
            }
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
                    let audioTour = AudioTour(id: tour.id, name: name, duration: duration, distance: distance, price: "\(price)", photoName: "https://devapi.test.vn.ua/storage/" + img)
                    allTours.append(audioTour)
                }
                strongSelf.allGuides = allTours
                DispatchQueue.main.async {
                    strongSelf.guideCollectionView.reloadData()
                }
                
            case .failure(let error):
                print("Tour get error : \(String(describing: error))")
            }
        }
    }
    private func setUpNoResultView() {
        viewNoLabel.backgroundColor = UIColor(hexString: "#fafafa")
        viewNoLabel.translatesAutoresizingMaskIntoConstraints = false
        viewNoLabel.accessibilityIdentifier = "noResultView"
        viewNoLabel.isHidden = true
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
            viewNoLabel.topAnchor.constraint(equalTo: searchFieldView.bottomAnchor),
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
    private func hideNoResultsLabel() {
        
        UIView.animate(withDuration: 0.3) {
            self.viewNoLabel.alpha = 0
        }completion: { _ in
            self.viewNoLabel.isHidden = true
        }
    }
    
    
    @available(iOSApplicationExtension, unavailable)
    private func setup() {
        self.scrollView.addSubview(self.mainView)
        self.searchField.attributedPlaceholder = NSAttributedString(string: "Search", attributes: [NSAttributedString.Key.foregroundColor: (UIColor(hexString: "#3C3C43").withAlphaComponent(0.6)), NSAttributedString.Key.font: UIFont.PoppinsFont(ofSize: 14)])
      
        self.cafeCollectionView.delegate = self
        self.cafeCollectionView.dataSource = self
        self.resultsView.resultsLocationsColectionView.delegate = self
        self.resultsView.resultsLocationsColectionView.dataSource = self
        self.resultsView.resultsToursColectionView.delegate = self
        self.resultsView.resultsToursColectionView.dataSource = self
        self.resultsView.resultsLocationsColectionView.register(ResultUICoCollectionViewCell.self, forCellWithReuseIdentifier: ResultUICoCollectionViewCell.identifier )
        self.resultsView.resultsToursColectionView.register(ResultTourUICoCollectionViewCell.self, forCellWithReuseIdentifier: ResultTourUICoCollectionViewCell.identifier )
        
    }
    private func setUpLocationCollectionView(){
        self.locationCollectionView.dataSource = self
        self.locationCollectionView.delegate = self
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        let spacing : CGFloat = 10
        let procentsWidth = 0.65
        let procentsHeight = 0.085
        let totalWidth = (screenWidth - spacing) * procentsWidth
        let totalHeight = screenHeight * procentsHeight
        layout.itemSize = CGSize(width: totalWidth, height: totalHeight)
        locationCollectionView.collectionViewLayout = layout
    }
    private func setUpGuideCollectionView(){
        self.guideCollectionView.dataSource = self
        self.guideCollectionView.delegate = self
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        let spacing : CGFloat = 8
        let procentsWidth = 0.65
        let procentsHeight = 0.30
        let totalWidth = (screenWidth - spacing) * procentsWidth
        let totalHeight = screenHeight * procentsHeight
        layout.itemSize = CGSize(width: totalWidth, height: totalHeight)
        guideCollectionView.collectionViewLayout = layout
    }

    @available(iOSApplicationExtension, unavailable)
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.scrollView.frame = CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y + safeAreaTopHeight, width: self.view.frame.width, height: self.view.frame.height - safeAreaTopHeight)
        self.mainView.frame = self.scrollView.frame
        self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height + AGMainTabBarController.tabBarHeight)
        setCollectionViewContentSize()
    }
    func setCollectionViewContentSize() {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        let spacing : CGFloat = 50
        let procentsWidth = 0.65
        let procentsHeight = 0.085
        let itemWidth = screenWidth * procentsWidth
        let totalHeight = screenHeight * procentsHeight
        let totalWidth = itemWidth * 6 + spacing
        locationCollectionView.contentSize = CGSize(width: totalWidth, height: totalHeight)
        }
    
    
    @IBAction private func showLocationListHandler(_ sender: UIButton) {
        self.performSegue(withIdentifier: "showLocationListSeque", sender: nil)
    }
    
    @IBAction private func showGuideListHandler(_ sender: UIButton) {
        self.performSegue(withIdentifier: "showGuideListSeque", sender: nil)
    }

    // MARK: - Navigation

    @IBAction private func unwindWithLocationListSegue(unwindSegue: UIStoryboardSegue) {
    }
    
    @IBAction private func unwindWithGuideListSegue(unwindSegue: UIStoryboardSegue) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }

}

// MARK: - UICollectionViewDataSource methods

extension AGAudioTourController: SkeletonCollectionViewDataSource {
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        switch skeletonView{
        case resultsView.resultsLocationsColectionView:
            return ResultUICoCollectionViewCell.identifier
        case resultsView.resultsToursColectionView:
            return ResultTourUICoCollectionViewCell.identifier
        default : return "cell"
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case locationCollectionView:
            return  allLocations.count
        case guideCollectionView:
            return  allGuides.count
        case cafeCollectionView:
            return  allCafes.count
        case resultsView.resultsLocationsColectionView:
            return filteredLocations.count
        case resultsView.resultsToursColectionView:
            return filteredGuides.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case locationCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AGLocationCollectionViewCell.identifier, for: indexPath) as? AGLocationCollectionViewCell else{
                fatalError()
            }
            let location = allLocations[indexPath.row]
            cell.setup(with: location)
            return cell
        case guideCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AGGuideCollectionViewCell.identifier, for: indexPath) as? AGGuideCollectionViewCell else{
                fatalError()
            }
            let guide = allGuides[indexPath.row]
            cell.setup(with: guide)
            cell.delegate = self
            return cell
        case cafeCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AGCafeCollectionViewCell", for: indexPath) as! AGCafeCollectionViewCell
            let cafe = allCafes[indexPath.row]
            cell.setup(with: cafe)
            return cell
        case resultsView.resultsLocationsColectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ResultUICoCollectionViewCell.identifier, for: indexPath) as? ResultUICoCollectionViewCell else{
                fatalError()
            }
                let location = filteredLocations[indexPath.row]
                cell.setup(with: location)
                return cell
        case resultsView.resultsToursColectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ResultTourUICoCollectionViewCell.identifier, for: indexPath) as? ResultTourUICoCollectionViewCell else{
                fatalError()
            }
                let tour = filteredGuides[indexPath.row]
                cell.setup(with: tour)
                return cell
        default:
            return UICollectionViewCell()
        }
    }
}
// MARK: - UICollectionViewDelegate methods

extension AGAudioTourController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        self.showLocationDetails()
        if collectionView == self.locationCollectionView{
            let choosedId = allLocations[indexPath.row].id
            self.showLocationDetails(choosedId: choosedId)
        }else if collectionView == self.guideCollectionView{
            let choosedId = allGuides[indexPath.row].id
            self.showTourDetails(choosedId: choosedId)
        }else{
            collectionView.deselectItem(at: indexPath, animated: true)
        }
        
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension AGAudioTourController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case locationCollectionView:
            let screenWidth = UIScreen.main.bounds.width
            let screenHeight = UIScreen.main.bounds.height
            let spacing : CGFloat = 10
            let procentsWidth = 0.65
            let procentsHeight = 0.085
            let totalWidth = (screenWidth - spacing) * procentsWidth
            let totalHeight = screenHeight * procentsHeight
            return CGSize(width: totalWidth, height: totalHeight)
        case guideCollectionView:
            let screenWidth = UIScreen.main.bounds.width
            let screenHeight = UIScreen.main.bounds.height
            let spacing : CGFloat = 8
            let procentsWidth = 0.65
            let procentsHeight = 0.30
            let totalWidth = (screenWidth - spacing) * procentsWidth
            let totalHeight = screenHeight * procentsHeight
            return CGSize(width: totalWidth, height: totalHeight)
        case cafeCollectionView:
            return CGSize(width: 132, height: 88)
        case resultsView.resultsLocationsColectionView:
            let screenWidth = UIScreen.main.bounds.width
            let screenHeight = UIScreen.main.bounds.height
            let spacing : CGFloat = 10
            let procentsWidth = 0.65
            let procentsHeight = 0.085
            let totalWidth = (screenWidth - spacing) * procentsWidth
            let totalHeight = screenHeight * procentsHeight
            return CGSize(width: totalWidth, height: totalHeight)
        case resultsView.resultsToursColectionView:
            let screenWidth = UIScreen.main.bounds.width
            let screenHeight = UIScreen.main.bounds.height
            let spacing : CGFloat = 8
            let procentsWidth = 0.65
            let procentsHeight = 0.30
            let totalWidth = (screenWidth - spacing) * procentsWidth
            let totalHeight = screenHeight * procentsHeight
            return CGSize(width: totalWidth, height: totalHeight)
        default:
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == locationCollectionView || collectionView == resultsView.resultsLocationsColectionView{
            return 10
        }else{
            return 16
        }
        
    }
}
extension AGAudioTourController : UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let searchText = textField.text , !searchText.isEmpty else{
            return true
        }
        if let oldConstraint = self.leadingConstrainMeetLabel {
            NSLayoutConstraint.deactivate([oldConstraint])
            self.leadingConstrainMeetLabel = self.meetLabel.leadingAnchor.constraint(equalTo: searchBackBtn.trailingAnchor, constant: 4)
            leadingConstrainMeetLabel?.isActive = true
        }
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3) {
                self.searchBackBtn.isHidden = false
                self.meetLabel.text = "Here's what we found"
                self.mainView.layoutIfNeeded()
            }
        }
        textField.resignFirstResponder()
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        guard let searchText = textField.text?.lowercased(), !searchText.isEmpty else {
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.3) {
                    self.resultsView.alpha = 0
                }completion: { _ in
                    self.resultsView.isHidden = true
                }
                self.hideNoResultsLabel()
            }
            return true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.apiCallWithSearchText(searchText: searchText)
        }
       
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Отримуємо новий текст після видалення або заміни символів
        guard let newText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string), !newText.isEmpty else {
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.3) {
                    self.resultsView.alpha = 0
                }completion: { _ in
                    self.resultsView.isHidden = true
                }
                self.hideNoResultsLabel()
                self.resultsView.resultsLocationsColectionView.stopSkeletonAnimation()
                self.resultsView.resultsLocationsColectionView.hideSkeleton()
            }
            return true
        }
        self.setUpSkelletonViews()
        self.resultsView.isHidden = false
        UIView.animate(withDuration: 0.3) {
            self.resultsView.alpha = 1
        }
        
        return true
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        guard let searchText = textField.text , !searchText.isEmpty else{
            print("Clear shit")
            return true
        }
        print("Clear good")
        if let oldConstraint = self.leadingConstrainMeetLabel {
            NSLayoutConstraint.deactivate([oldConstraint])
            self.leadingConstrainMeetLabel = self.meetLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 16)
            leadingConstrainMeetLabel?.isActive = true
        }
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3) {
                self.searchBackBtn.isHidden = true
                self.meetLabel.text = "Nice to meet you in Lviv!"
                self.mainView.layoutIfNeeded()
            }
        }
        textField.resignFirstResponder()
        return true
    }
}
extension AGAudioTourController :  AGGuideCollectionViewCellDelegate{
    func guideCellDidTapLikeButton() {
        DispatchQueue.main.async {
            self.noAccountPopUp.isHidden = false
            UIView.animate(withDuration: 0.3) {
                self.noAccountPopUp.alpha = 1.0
            }
        }
    }
}
