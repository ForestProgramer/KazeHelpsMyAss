//
//  AGLocationListViewController.swift
//  AudioGuide
//
//  Created by Sergej Bekker on 21.02.2022.
//

import UIKit
import SkeletonView
import UIScrollView_InfiniteScroll
import InstantSearchVoiceOverlay
class AGLocationListViewController: AGViewController {
    let apiCall = APIManager.shared
    let mainView : UIView = {
       let view = UIView()
        view.backgroundColor = UIColor(hexString: "#FAFAFA")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let backDoorBtn : UIButton = {
        let btn = UIButton(type: .custom)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(named: "backDoorImage"), for: .normal)
        btn.contentMode = .scaleAspectFit
        btn.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return btn
    }()
    let titleVisit : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = UIColor(hexString: "#3D3E42")
        label.textAlignment = .left
        label.text = "Must visit"
        return label
    }()
    let searchView : UIView = {
       let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8
        return view
    }()
    let searchImageView : UIImageView = {
       let imageView = UIImageView(image: UIImage(named: "search_icon"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    let textField : UITextField = {
       let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.placeholder = "Search..."
        field.font = UIFont(name: "Poppins", size: 15)
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .search
        field.clearButtonMode = .always
        return field
    }()
    let voiceSearchBtn : UIButton = {
        let btn = UIButton(type: .custom)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(named: "microphone_icon"), for: .normal)
        btn.contentMode = .scaleAspectFit
        btn.addTarget(self, action: #selector(didTapVoiceSearch), for: .touchUpInside)
        return btn
    }()
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        // Відступи по краях
        let insets: CGFloat = 32.0
        // Висота екрана айфона помножена на 0.085
        let itemHeight = UIScreen.main.bounds.height * 0.085
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 2 * insets, height: itemHeight)
        layout.sectionInset = UIEdgeInsets(top: insets, left: insets, bottom: insets, right: insets)
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 16
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(ResultUICoCollectionViewCell.self, forCellWithReuseIdentifier: "allLocations")
        return collectionView
    }()
    private let voiceOverlay = VoiceOverlayController()
    private var allLocations : [Location] = [Location(name: "", street: "", photoName: ""),Location(name: "", street: "", photoName: ""),Location(name: "", street: "", photoName: ""),Location(name: "", street: "", photoName: ""),Location(name: "", street: "", photoName: ""),Location(name: "", street: "", photoName: ""),Location(name: "", street: "", photoName: ""),Location(name: "", street: "", photoName: ""),Location(name: "", street: "", photoName: ""),Location(name: "", street: "", photoName: ""),]
    private var filteredLocations : [Location] = [Location(name: "", street: "", photoName: ""),Location(name: "", street: "", photoName: ""),Location(name: "", street: "", photoName: ""),Location(name: "", street: "", photoName: ""),Location(name: "", street: "", photoName: ""),Location(name: "", street: "", photoName: ""),Location(name: "", street: "", photoName: ""),Location(name: "", street: "", photoName: ""),Location(name: "", street: "", photoName: ""),Location(name: "", street: "", photoName: "")]
    private var pageToLoad : Int = 2
    private let viewNoLabel = UIView()
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUIElements()
        textField.delegate = self
        setUpNoResultView()
    }
    @objc private func didTapVoiceSearch(){
        voiceOverlay.start(on: self, textHandler: {text , final, _ in
            if final{
                DispatchQueue.main.async {
                    self.textField.text = text // Присвоюємо текст поля пошуку
                    self.checkSearchField() // Викликаємо функцію для перевірки тексту у полі пошуку
                }
            }
        }, errorHandler: {error in
            
        }, resultScreenHandler: nil)
    }
    private func checkSearchField() {
        guard let searchText = textField.text?.lowercased(), !searchText.isEmpty else {
            // Якщо поле пошуку не пусте, показуємо resultsView
            DispatchQueue.main.async {
                self.collectionView.stopSkeletonAnimation()
                self.collectionView.hideSkeleton()
                self.collectionView.reloadData()
            }
            return
        }
        DispatchQueue.main.async {
            self.setUpSkelletonView()
            self.filterLocations(with: searchText)
        }
        
    }
    private func setUpUIElements() {
        view.addSubview(mainView)
        mainView.addSubview(backDoorBtn)
        mainView.addSubview(titleVisit)
        mainView.addSubview(searchView)
        searchView.addSubview(searchImageView)
        searchView.addSubview(textField)
        searchView.addSubview(voiceSearchBtn)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor(hexString: "#FAFAFA")
        mainView.addSubview(collectionView)

        NSLayoutConstraint.activate([
            mainView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainView.topAnchor.constraint(equalTo: view.topAnchor, constant: safeAreaTopHeight + 85),
            mainView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            backDoorBtn.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 16),
            backDoorBtn.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 2),
            backDoorBtn.widthAnchor.constraint(equalToConstant: 32), // Додайте це
            backDoorBtn.heightAnchor.constraint(equalToConstant: 32), // Додайте це
            
            titleVisit.leadingAnchor.constraint(equalTo: backDoorBtn.trailingAnchor, constant: 4),
            titleVisit.centerYAnchor.constraint(equalTo: backDoorBtn.centerYAnchor),
            
            searchView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor,constant: 16),
            searchView.topAnchor.constraint(equalTo: titleVisit.bottomAnchor,constant: 16),
            searchView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor,constant: -16),
            searchView.heightAnchor.constraint(equalToConstant: 40),
            
            searchImageView.centerYAnchor.constraint(equalTo: searchView.centerYAnchor),
            searchImageView.leadingAnchor.constraint(equalTo: searchView.leadingAnchor,constant: 8),
            searchImageView.topAnchor.constraint(equalTo: searchView.topAnchor,constant: 11),
            searchImageView.bottomAnchor.constraint(equalTo: searchView.bottomAnchor,constant: -11),
            
            voiceSearchBtn.trailingAnchor.constraint(equalTo: searchView.trailingAnchor,constant: -8),
            voiceSearchBtn.topAnchor.constraint(equalTo: searchView.topAnchor,constant: 8),
            voiceSearchBtn.bottomAnchor.constraint(equalTo: searchView.bottomAnchor,constant: -8),
            voiceSearchBtn.widthAnchor.constraint(equalToConstant: 24),
        
            textField.centerYAnchor.constraint(equalTo: searchView.centerYAnchor),
            textField.leadingAnchor.constraint(equalTo: searchImageView.trailingAnchor, constant: 4),
            textField.trailingAnchor.constraint(equalTo: voiceSearchBtn.leadingAnchor, constant: 4),
            textField.widthAnchor.constraint(equalToConstant: 281),
            
            collectionView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: searchView.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: searchView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor),
           
        ])
    }
    // Метод, який викликається при натисканні кнопки "Back"
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpSkelletonView()
        guard let idDevice = UserDefaults.standard.value(forKey: "id_device") as? String else{
            return
        }
        apiCall.getPoints(idDevice: idDevice,with: 1) {[weak self] result in
            guard let strongSelf = self else{
                return
            }
            switch result {
            case .success(let pointModel):
                let points = pointModel.data
                var locations = [Location]()
                for (_,point) in points.enumerated(){
                    let name = point.pointLangData.first?.name ?? "Unknown"
                    let street = point.pointLangData.first?.address ?? "Unknown"
                    let photoName = point.img
                    let location = Location(name: name, street: street, photoName: "https://seeklogo.com/images/L/lviv-logo-856C608840-seeklogo.com.png")
                    locations.append(location)
                }
                DispatchQueue.main.async {
                    strongSelf.allLocations = locations
                    strongSelf.collectionView.stopSkeletonAnimation()
                    strongSelf.collectionView.hideSkeleton()
                    strongSelf.collectionView.reloadData()
                }
            case .failure(let error):
                print("Point get error : \(String(describing: error))")
            }
        }
        collectionView.infiniteScrollDirection = .vertical
        collectionView.addInfiniteScroll {[weak self] collection in
            guard let strongSelf = self else{
                return
            }
            strongSelf.apiCall.getPoints(idDevice: idDevice,with: strongSelf.pageToLoad) {[weak self] result in
                switch result{
                case .success(let pointModel):
                    let points = pointModel.data
                    var locations = [Location]()
                    for (_,point) in points.enumerated(){
                        let name = point.pointLangData.first?.name ?? "Unknown"
                        let street = point.pointLangData.first?.address ?? "Unknown"
                        let photoName = point.img
                        let location = Location(name: name, street: street, photoName: "https://seeklogo.com/images/L/lviv-logo-856C608840-seeklogo.com.png")
                        locations.append(location)
                    }
                    DispatchQueue.main.async {
                        strongSelf.allLocations.append(contentsOf: locations)
                        collection.reloadData()
                    }
                case .failure(let error):
                    print("Point get error : \(String(describing: error))")
                }
            }
            if strongSelf.pageToLoad < 5{
            strongSelf.pageToLoad += 1
            }
            collection.finishInfiniteScroll()
        }
    }
    private func setUpSkelletonView(){
        collectionView.isSkeletonable = true
        collectionView.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .systemGray3, secondaryColor: .systemGray6), animation: nil, transition: .crossDissolve(0.25))
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

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    

}

// MARK: - UITableViewDataSource methods

extension AGLocationListViewController: SkeletonCollectionViewDataSource {
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "allLocations"
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let searchText = self.textField.text, !searchText.isEmpty {
            return filteredLocations.count
        } else {
            return allLocations.count
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "allLocations", for: indexPath) as? ResultUICoCollectionViewCell else{
            fatalError()
        }
        let location : Location
        if let searchText = self.textField.text, !searchText.isEmpty {
            // Якщо текстове поле не порожнє, використовуйте відфільтрований масив локацій
            location = filteredLocations[indexPath.row]
        } else {
            // Якщо текстове поле порожнє, використовуйте звичайний масив локацій
            location = allLocations[indexPath.row]
        }
        cell.setup(with: location)
        return cell
    }
}

// MARK: - UITableViewDelegate methods

extension AGLocationListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.showLocationDetails()
    }
}
extension AGLocationListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        let padding = 32.0
        let procentsHeight = 0.085
        let totalWidth = screenWidth - padding
        let totalHeight = screenHeight * procentsHeight
        return CGSize(width: totalWidth, height: totalHeight)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
}
extension AGLocationListViewController : UITextFieldDelegate{
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
                self.collectionView.stopSkeletonAnimation()
                self.collectionView.hideSkeleton()
                self.collectionView.reloadData()
            }
        }
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        filterLocations(with: textField.text)
        return true
    }
    func setUPSearchSkelleton(){
        collectionView.isSkeletonable = true
        collectionView.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .systemGray3, secondaryColor: .systemGray6), animation: nil, transition: .crossDissolve(0.25))
    }
    // Функція фільтрації локацій
    func filterLocations(with searchText: String?) {
        guard let idDevice = UserDefaults.standard.value(forKey: "id_device") as? String, let searchText = searchText?.lowercased(), !searchText.isEmpty else {
            // Якщо текстове поле порожнє, очистіть масив відфільтрованих локацій
            filteredLocations = [Location(name: "", street: "", photoName: ""),Location(name: "", street: "", photoName: ""),Location(name: "", street: "", photoName: ""),Location(name: "", street: "", photoName: ""),Location(name: "", street: "", photoName: ""),Location(name: "", street: "", photoName: ""),Location(name: "", street: "", photoName: ""),Location(name: "", street: "", photoName: ""),Location(name: "", street: "", photoName: ""),Location(name: "", street: "", photoName: "")]
            collectionView.reloadData() // Оновіть колекційне представлення
            return
        }
        self.apiCall.getSearchResults(idDevice: idDevice, keywords: searchText, orderBy: .id, sort: .desc, typeFilter: .locations, mode: .toursInPoints,responseType: LocationDataDetails.self) { [weak self] (result: Result<LocationDataDetails, Error>) in
            guard let strongSelf = self else{
                return
            }
            switch result {
            case .success(let searchResults):
                let data = searchResults.data
                var locations = [Location]()
                for (_,point) in data.enumerated(){
                    let name = point.pointLangData.first?.name ?? "Unknown"
                    let street = point.pointLangData.first?.address ?? "Unknown"
                    let photoName = point.img
                    let location = Location(name: name, street: street, photoName: "https://seeklogo.com/images/L/lviv-logo-856C608840-seeklogo.com.png")
                    locations.append(location)
                }
               
                DispatchQueue.main.async {
                    strongSelf.filteredLocations = locations
                    //                    strongSelf.hideNoResultsLabel()
                    //                    strongSelf.resultsView.isHidden = false
                    strongSelf.collectionView.stopSkeletonAnimation()
                    strongSelf.collectionView.hideSkeleton()
                    strongSelf.collectionView.reloadData()
                }
            case .failure(let error):
                print("Error fetching search results: \(error)")
                DispatchQueue.main.async {
                    strongSelf.collectionView.stopSkeletonAnimation()
                    strongSelf.collectionView.hideSkeleton()
                    strongSelf.viewNoLabel.isHidden = false
                    UIView.animate(withDuration: 0.3) {
                        strongSelf.viewNoLabel.alpha = 1
                    }
                   
                }
            }
        }
    }
}
