//
//  DetailsViewController.swift
//  AudioGuide
//
//  Created by Максим Оліярник on 04.03.2024.
//

import UIKit
import Cosmos
class DetailsViewController: AGViewController {
    let apiCall = APIManager.shared
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = true
//        scrollView.translatesAutoresizingMaskIntoConstraints = falsed
        scrollView.showsVerticalScrollIndicator = true
        scrollView.isDirectionalLockEnabled = false
        return scrollView
    }()
    let mainView = LocationBottomSheetView()
    let tourMainView = TourDetailsUIView()
    var isTourEmpty :Bool = false
    var isPointsEmpty :Bool = false
    var toursForLocation : [AudioTour] = []
    var pointInTours : [Location] = []
    var usersReviews : [UsersComments] = []
    var detailsLocationData : (pointId : Int,type : String, rate : Int?, title : String?, duration : String?, street : String?, description: String?, tours : [AudioTour])?
    var detailToursData : (type : String, rate : Int?, title : String?, duration : String?, description: String?, points : [Location])?
    var isOverViewButtonSelected = true
    private let maxHeight: CGFloat = 150
    private let minHeight: CGFloat = 50
    private let typeOfDetails : DetailsType?
    init(withType typeDetail : DetailsType, id : Int, type: String, rate: Int?, title: String?, duration: String?, street: String?, description: String?, tours: [AudioTour],comments : [UsersComments], isTourEmpty : Bool) {
        self.detailsLocationData = (pointId : id, type: type, rate: rate, title: title, duration: duration, street: street, description: description, tours: tours)
        self.isTourEmpty = isTourEmpty
        self.usersReviews = comments
        self.typeOfDetails = typeDetail
        super.init(nibName: nil, bundle: nil)
    }
    init(withType typeDetails : DetailsType, id : Int,type: String, rate: Int?, title: String?, duration: String?, description: String?, points: [Location],comments : [UsersComments], isPointsEmpty : Bool) {
        self.detailToursData = (type: type, rate: rate, title: title, duration: duration, description: description, points: points)
        self.isPointsEmpty = isPointsEmpty
        self.usersReviews = comments
        self.typeOfDetails = typeDetails
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setUpConstraints()
        setUpTextViewDelegate()
    }
    private func congigureViewData(){
        if typeOfDetails == .location{
            guard let type = detailsLocationData?.type, let title = detailsLocationData?.title , let street = detailsLocationData?.street, let description = detailsLocationData?.description, let tours = detailsLocationData?.tours else{
                return
            }
            DispatchQueue.main.async {
                print("Passed data successfully")
                self.toursForLocation = tours
                self.mainView.toursCollectionView.reloadData()
                self.mainView.typeLabel.text = type == "point" ? "Audio guide" : "Audio Tour"
                self.mainView.rateImageView.rating = Double(self.detailsLocationData?.rate ?? 0)
                self.mainView.locationTitleLabel.text = title
                self.mainView.locationGuideLabel.text = street
                self.mainView.overviewLabel.text = description
                
                
                if self.isTourEmpty{
                    ///ховаєм label і collectionView і міняємо розміри mainView
                    self.mainView.locationInAudioGuidesLabel.isHidden = true
                    self.mainView.toursCollectionView.isHidden = true
                    self.mainView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.calculateContentHeight())
                }else{
                    ///показуєм label і collectionView і міняємо розміри mainView
                    self.mainView.locationInAudioGuidesLabel.isHidden = false
                    self.mainView.toursCollectionView.isHidden = false
                    self.mainView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.calculateContentHeight())
                }
            }
        }else{
            guard let type = detailToursData?.type, let title = detailToursData?.title, let description = detailToursData?.description, let points = detailToursData?.points else{
                return
            }
            DispatchQueue.main.async {
                print("Passed data successfully")
                self.pointInTours = points
                self.setHeightForOverviewView()
                self.tourMainView.pointsCollectionView.reloadData()
                self.tourMainView.typeLabel.text = type == "point" ? "Audio guide" : "Audio Tour"
                self.tourMainView.locationTitleLabel.text = title
                self.tourMainView.overviewLabel.text = description
                
                if self.isPointsEmpty{
                    ///ховаєм label і collectionView і міняємо розміри tourtourMainView
                    self.tourMainView.youWillSeeTourLabel.isHidden = true
                    self.tourMainView.pointsCollectionView.isHidden = true
                    self.tourMainView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.calculateContentHeight())
                    self.view.layoutIfNeeded()
                }else{
                    ///показуєм label і collectionView і міняємо розміри tourtourMainView
                    self.tourMainView.youWillSeeTourLabel.isHidden = false
                    self.tourMainView.pointsCollectionView.isHidden = false
                    self.tourMainView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.calculateContentHeight())
                    self.scrollView.layoutIfNeeded()
                }
            }
        }
        
    }
    private func setHeightForOverviewView(){
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        let itemHeightPercentage: CGFloat = 0.122 // Задайте відсоток від висоти екрану для висоти елемента
        let itemHeight = screenHeight * itemHeightPercentage
        let estimatedHeigh = itemHeight * CGFloat(self.pointInTours.count)
        if let oldConstraint = self.tourMainView.pointsCollectionViewHeightConstraint {
            oldConstraint.isActive = false // Деактивувати старий констрейнт
        }
        let newConstraint = self.tourMainView.pointsCollectionView.heightAnchor.constraint(equalToConstant: estimatedHeigh)
        newConstraint.isActive = true // Активувати новий констрейнт
        self.tourMainView.pointsCollectionViewHeightConstraint = newConstraint
    }
    private func setUpConstraints(){
        setUpScrollView()
        setUpCollectionView()
        setUpButtonsSwitch()
        addAbilityToAddComment()
    }
    private func setUpTextViewDelegate(){
        switch typeOfDetails {
        case .location:
            mainView.containerWriteComment.commentTextView.delegate = self
        case .tour:
            tourMainView.containerWriteComment.commentTextView.delegate = self
        case nil:
           return
        }
        
    }
    private func setUpButtonsSwitch(){
        switch typeOfDetails {
        case .location:
            mainView.reviewsBtn.addTarget(self, action: #selector(didTapReviewsBtn), for: .touchUpInside)
            mainView.overViewBtn.addTarget(self, action: #selector(didTapOverViewBtn), for: .touchUpInside)
        case .tour:
            tourMainView.reviewsBtn.addTarget(self, action: #selector(didTapReviewsBtn), for: .touchUpInside)
            tourMainView.overViewBtn.addTarget(self, action: #selector(didTapOverViewBtn), for: .touchUpInside)
        case nil:
            return
        }
       
    }
    private func addAbilityToAddComment(){
        switch typeOfDetails {
        case .location:
            mainView.containerWriteComment.sendCommentButton.addTarget(self, action: #selector(didTapSendCommentButton), for: .touchUpInside)
        case .tour:
            tourMainView.containerWriteComment.sendCommentButton.addTarget(self, action: #selector(didTapSendCommentButton), for: .touchUpInside)
        case nil:
            return
        }
        
    }
    @objc private func didTapSendCommentButton(){
//        guard let idDevice = UserDefaults.standard.value(forKey: "id_device") as? String, let token = UserDefaults.userBearerToken, let id = detailsData?.pointId, let newComment = mainView.containerWriteComment.commentTextView.text else{
//            return
//        }
//        print("Id device : \(idDevice)\n Token : \(token)\nId point : \(id)\nPassed comment : \(newComment)")
//        let rating = mainView.containerWriteComment.rateImageView.rating
//        apiCall.addComment(idDevice: idDevice, token: token, idPoint: id, comment: newComment, rating: Int(rating)) { result in
//            switch result {
//            case .success(let success):
//                print("Succes sended comment : \(success)")
                
//                var newComments : [OneLocationComment] = []
//                DispatchQueue.main.async {
//                    self.usersReviews.removeAll()
//                    for newCommentData in success.data{
//                        newComments.append(OneLocationComment(id: newCommentData.id, idPoint: newCommentData.idPoint, idUser: newCommentData.idUser, comment: newCommentData.comment, active: newCommentData.active, createdAt: newCommentData.createdAt, updatedAt: newCommentData.updatedAt, user: UserCommentInfo(name: "No name", avatar: "")))
//                    }
//                    self.usersReviews = newComments
//                    self.mainView.containerWriteComment.commentTextView.text.removeAll()
//                    var totalHeight: CGFloat = 0
//                    print("UsersReviews count : \(self.usersReviews.count)")
//                    for review in self.usersReviews {
//                        let commentText = review.comment
//                        let labelWidth = UIScreen.main.bounds.width - 52
//                        let labelFont = UIFont.PoppinsFont(ofSize: 12, weight: .regular)
//                        let commentTextSize = NSString(string: commentText).boundingRect(with: CGSize(width: labelWidth, height: .greatestFiniteMagnitude), options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font: labelFont], context: nil).size
//                        let itemHeight = commentTextSize.height + 61
//                        totalHeight += itemHeight
//                    }
//                    if let oldConstraint = self.mainView.reviewsCollectionViewHeightConstraint {
//                        oldConstraint.isActive = false // Деактивувати старий констрейнт
//                    }
//                    let newConstraint = self.mainView.reviewsCollectionView.heightAnchor.constraint(equalToConstant: totalHeight)
//                    newConstraint.isActive = true // Активувати новий констрейнт
//                    self.mainView.reviewsCollectionViewHeightConstraint = newConstraint
//                    self.mainView.reviewsCollectionView.reloadData()
//                    self.scrollView.contentSize = CGSize(width: self.scrollView.bounds.size.width, height: self.calculateContentHeight())
//                    self.scrollView.layoutIfNeeded()
//                }
//            case .failure(let failure):
//                print("Failed to send comment : \(failure)")
//            }
//        }
    }
    @objc private func didTapOverViewBtn(){
        switch typeOfDetails {
        case .location:
            if !isOverViewButtonSelected{
                DispatchQueue.main.async {
                    print("Tapped OverViewBtn")
                    self.mainView.overViewBtn.titleLabel?.font = UIFont.PoppinsFont(ofSize: 20,weight: .medium)
                    self.mainView.reviewsBtn.titleLabel?.font = UIFont.PoppinsFont(ofSize: 18,weight: .regular)
                    self.mainView.reviewsView.isHidden = true
                    self.mainView.overView.isHidden = false
                    self.isOverViewButtonSelected = true
                    self.mainView.toursCollectionView.reloadData()
                    self.scrollView.contentSize = CGSize(width: self.scrollView.bounds.size.width, height: self.calculateContentHeight())
                    self.scrollView.layoutIfNeeded()
                }
                
            }
        case .tour:
            if !isOverViewButtonSelected{
                DispatchQueue.main.async {
                    print("Tapped OverViewBtn")
                    self.tourMainView.overViewBtn.titleLabel?.font = UIFont.PoppinsFont(ofSize: 20,weight: .medium)
                    self.tourMainView.reviewsBtn.titleLabel?.font = UIFont.PoppinsFont(ofSize: 18,weight: .regular)
                    self.tourMainView.reviewsView.isHidden = true
                    self.tourMainView.overView.isHidden = false
                    self.isOverViewButtonSelected = true
                    self.tourMainView.pointsCollectionView.reloadData()
                    self.scrollView.contentSize = CGSize(width: self.scrollView.bounds.size.width, height: self.calculateContentHeight())
                    self.scrollView.layoutIfNeeded()
                }
            }
        case nil:
            return
        }
       
    }
    @objc private func didTapReviewsBtn() {
        switch typeOfDetails {
        case .location:
            if isOverViewButtonSelected {
                self.mainView.overViewBtn.titleLabel?.font = UIFont.PoppinsFont(ofSize: 18, weight: .regular)
                self.mainView.reviewsBtn.titleLabel?.font = UIFont.PoppinsFont(ofSize: 20, weight: .medium)
                self.mainView.reviewsView.isHidden = false
                self.mainView.overView.isHidden = true
                self.isOverViewButtonSelected = false
                
               
    //            // Оновлення констрейнтів та розмірів після зміни виду
                DispatchQueue.main.async {
                    var totalHeight: CGFloat = 0
                    print("UsersReviews count : \(self.usersReviews.count)")
                    for review in self.usersReviews {
                        let commentText = review.comment
                        let labelWidth = UIScreen.main.bounds.width - 52
                        let labelFont = UIFont.PoppinsFont(ofSize: 12, weight: .regular)
                        let commentTextSize = NSString(string: commentText).boundingRect(with: CGSize(width: labelWidth, height: .greatestFiniteMagnitude), options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font: labelFont], context: nil).size
                        let itemHeight = commentTextSize.height + 61
                        totalHeight += itemHeight
                    }
                    if let oldConstraint = self.mainView.reviewsCollectionViewHeightConstraint {
                        oldConstraint.isActive = false // Деактивувати старий констрейнт
                    }
                    let newConstraint = self.mainView.reviewsCollectionView.heightAnchor.constraint(equalToConstant: totalHeight)
                    newConstraint.isActive = true // Активувати новий констрейнт
                    self.mainView.reviewsCollectionViewHeightConstraint = newConstraint
                    self.mainView.reviewsCollectionView.reloadData()
                    self.scrollView.contentSize = CGSize(width: self.scrollView.bounds.size.width, height: self.calculateContentHeight())
                    self.scrollView.layoutIfNeeded()
                }
            }
        case .tour:
            if isOverViewButtonSelected {
                self.tourMainView.overViewBtn.titleLabel?.font = UIFont.PoppinsFont(ofSize: 18, weight: .regular)
                self.tourMainView.reviewsBtn.titleLabel?.font = UIFont.PoppinsFont(ofSize: 20, weight: .medium)
                self.tourMainView.reviewsView.isHidden = false
                self.tourMainView.overView.isHidden = true
                self.isOverViewButtonSelected = false
                
               
    //            // Оновлення констрейнтів та розмірів після зміни виду
                DispatchQueue.main.async {
                    var totalHeight: CGFloat = 0
                    print("UsersReviews count : \(self.usersReviews.count)")
                    for review in self.usersReviews {
                        let commentText = review.comment
                        let labelWidth = UIScreen.main.bounds.width - 52
                        let labelFont = UIFont.PoppinsFont(ofSize: 12, weight: .regular)
                        let commentTextSize = NSString(string: commentText).boundingRect(with: CGSize(width: labelWidth, height: .greatestFiniteMagnitude), options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font: labelFont], context: nil).size
                        let itemHeight = commentTextSize.height + 61
                        totalHeight += itemHeight
                    }
                    if let oldConstraint = self.tourMainView.reviewsCollectionViewHeightConstraint {
                        oldConstraint.isActive = false // Деактивувати старий констрейнт
                    }
                    let newConstraint = self.tourMainView.reviewsCollectionView.heightAnchor.constraint(equalToConstant: totalHeight)
                    newConstraint.isActive = true // Активувати новий констрейнт
                    self.tourMainView.reviewsCollectionViewHeightConstraint = newConstraint
                    self.tourMainView.reviewsCollectionView.reloadData()
                    self.scrollView.contentSize = CGSize(width: self.scrollView.bounds.size.width, height: self.calculateContentHeight())
                    self.scrollView.layoutIfNeeded()
                }
            }
        case nil:
            return
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        scrollView.contentSize = CGSize(width: scrollView.bounds.size.width, height: calculateContentHeight())
        switch typeOfDetails {
        case .location:
            mainView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: calculateContentHeight())
            mainView.overView.frame = CGRect(x: 0, y: 170, width: scrollView.contentSize.width, height: scrollView.contentSize.height)
            mainView.reviewsView.frame = CGRect(x: 0, y: 170, width: scrollView.contentSize.width, height: scrollView.contentSize.height)
        case .tour:
            tourMainView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: calculateContentHeight())
            tourMainView.overView.frame = CGRect(x: 0, y: 170, width: scrollView.contentSize.width, height: scrollView.contentSize.height)
            tourMainView.reviewsView.frame = CGRect(x: 0, y: 170, width: scrollView.contentSize.width, height: scrollView.contentSize.height)
        case nil:
            return
        }
       
    }
    private func calculateContentHeight() -> CGFloat {
        switch typeOfDetails {
        case .location:
            if isOverViewButtonSelected{
                let elementsOffset : CGFloat = isTourEmpty ? 110 : 150
                let estimatedHeight = isTourEmpty ? mainView.typeLabel.frame.size.height + mainView.locationTitleLabel.frame.size.height + mainView.durationGuideImageView.frame.size.height + mainView.overViewBtn.frame.size.height + mainView.overviewLabel.frame.size.height  + elementsOffset : mainView.typeLabel.frame.size.height + mainView.locationTitleLabel.frame.size.height + mainView.durationGuideImageView.frame.size.height + mainView.overViewBtn.frame.size.height + mainView.overviewLabel.frame.size.height + mainView.locationInAudioGuidesLabel.frame.size.height + mainView.toursCollectionView.frame.size.height + elementsOffset
                return estimatedHeight
            }else{
                let elementsOffset : CGFloat = 170
                let writeContainerHeight = mainView.containerWriteComment.frame.size.height
                let estimatedHeight = mainView.reviewsCollectionView.frame.size.height + writeContainerHeight + elementsOffset
                return estimatedHeight
            }
        case .tour:
            if isOverViewButtonSelected{
                let elementsOffset : CGFloat = isPointsEmpty ? 110 : 110
                let estimatedHeight = isPointsEmpty ? tourMainView.typeLabel.frame.size.height + tourMainView.locationTitleLabel.frame.size.height + tourMainView.durationGuideImageView.frame.size.height + tourMainView.overViewBtn.frame.size.height + tourMainView.overviewLabel.frame.size.height  + elementsOffset : tourMainView.typeLabel.frame.size.height + tourMainView.locationTitleLabel.frame.size.height + tourMainView.durationGuideImageView.frame.size.height + tourMainView.overViewBtn.frame.size.height + tourMainView.overviewLabel.frame.size.height + tourMainView.youWillSeeTourLabel.frame.size.height + tourMainView.pointsCollectionView.frame.size.height + elementsOffset
                return estimatedHeight
            }else{
                let elementsOffset : CGFloat = 170
                let writeContainerHeight = tourMainView.containerWriteComment.frame.size.height
                let estimatedHeight = tourMainView.reviewsCollectionView.frame.size.height + writeContainerHeight + elementsOffset
                return estimatedHeight
            }
        case nil:
            return 0.0
        }
    }
    private func setUpScrollView(){
        view.addSubview(scrollView) // Додаємо scrollView на view контролера
        switch typeOfDetails {
        case .location:
            scrollView.addSubview(mainView)
        case .tour:
            scrollView.addSubview(tourMainView)
        case nil:
           return
        }
        DispatchQueue.main.async {
            self.congigureViewData()
        }
    }
    private func setUpCollectionView(){
        switch typeOfDetails {
        case .location:
            mainView.toursCollectionView.delegate = self
            mainView.toursCollectionView.dataSource = self
            mainView.toursCollectionView.register(DescCollectionViewCell.self, forCellWithReuseIdentifier: DescCollectionViewCell.identifier)
            
            mainView.reviewsCollectionView.delegate = self
            mainView.reviewsCollectionView.dataSource = self
            mainView.reviewsCollectionView.register(UserReviewsCollectionViewCell.self, forCellWithReuseIdentifier: UserReviewsCollectionViewCell.identifier)
        case .tour:
            tourMainView.pointsCollectionView.delegate = self
            tourMainView.pointsCollectionView.dataSource = self
            tourMainView.pointsCollectionView.register(ResultUICoCollectionViewCell.self, forCellWithReuseIdentifier: "allLocations")
            tourMainView.reviewsCollectionView.delegate = self
            tourMainView.reviewsCollectionView.dataSource = self
            tourMainView.reviewsCollectionView.register(UserReviewsCollectionViewCell.self, forCellWithReuseIdentifier: UserReviewsCollectionViewCell.identifier)
        case nil:
            return
        }
    }

}
extension DetailsViewController : UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isOverViewButtonSelected{
            switch self.typeOfDetails{
            case .location:
                return toursForLocation.count
            case .tour:
                return pointInTours.count
            case nil:
                return 0
            }
        }else{
            return usersReviews.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isOverViewButtonSelected{
            switch typeOfDetails{
            case .location:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DescCollectionViewCell.identifier, for: indexPath) as? DescCollectionViewCell else{
                    fatalError()
                }
                let tour = toursForLocation[indexPath.row]
                cell.configure(with: tour)
                return cell
            case .tour:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "allLocations", for: indexPath) as? ResultUICoCollectionViewCell else{
                    fatalError()
                }
                let point = pointInTours[indexPath.row]
                cell.setup(with: point)
                return cell
            case nil:
                return UICollectionViewCell()
            }
           
        }else{
            switch typeOfDetails{
            case .location:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserReviewsCollectionViewCell.identifier, for: indexPath) as? UserReviewsCollectionViewCell else {
                    fatalError()
                }
                let comment = usersReviews[indexPath.item] // Вираховуємо правильний індекс для usersReviews
                cell.configureReview(with: comment)
                return cell
            case .tour:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserReviewsCollectionViewCell.identifier, for: indexPath) as? UserReviewsCollectionViewCell else {
                    fatalError()
                }
                let comment = usersReviews[indexPath.item] // Вираховуємо правильний індекс для
                cell.configureReview(with: comment)
                return cell
            case nil:
                return UICollectionViewCell()
            }
            
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == mainView.toursCollectionView{
            let choosedId = toursForLocation[indexPath.row].id
            self.showTourDetails(choosedId: choosedId)
        }else if collectionView == tourMainView.pointsCollectionView{
            let choosedId = pointInTours[indexPath.row].id
            self.showLocationDetails(choosedId: choosedId)
        }
    }
}
extension DetailsViewController : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if isOverViewButtonSelected{
            switch typeOfDetails{
            case .location:
                let screenWidth = UIScreen.main.bounds.width
                let screenHeight = UIScreen.main.bounds.height
                let itemHeightPercentage: CGFloat = 0.289
                let itemHeight = screenHeight * itemHeightPercentage
                let itemWidthtPercentage: CGFloat = 0.58
                let itemWidth = screenWidth * itemWidthtPercentage
                return CGSize(width: itemWidth, height: itemHeight)
            case .tour:
                let layout = UICollectionViewFlowLayout()
                let insets: CGFloat = 32.0
                // Висота екрана айфона помножена на 0.085
                let itemHeight = UIScreen.main.bounds.height * 0.085
                let itemWidth = UIScreen.main.bounds.width - insets
                layout.sectionInset = UIEdgeInsets(top: insets, left: insets, bottom: insets, right: insets)
                return CGSize(width: itemWidth, height: itemHeight)
            case nil:
                return CGSize(width: 0, height: 0)
            }
        }else{
//            let commentText = "Lorem Ipsum is simply dummy text of the printing and typesetting industry.Lorem Ipsum is simply dummy text of the printing and typesetting industry.Lorem Ipsum is simply dummy text of the printing and typesetting industry."
            let commentText = usersReviews[indexPath.row].comment
            let screenWidth = UIScreen.main.bounds.width
            let labelWidth = screenWidth - 52
            let labelFont = UIFont.PoppinsFont(ofSize: 12, weight: .regular)
            let commentTextSize = NSString(string: commentText).boundingRect(with: CGSize(width: labelWidth, height: .greatestFiniteMagnitude), options: [.usesLineFragmentOrigin, .usesFontLeading],attributes: [NSAttributedString.Key.font: labelFont], context: nil).size
            let itemHeight = commentTextSize.height + 60
            //                print("ItemHeight : \(itemHeight)")
            return CGSize(width: screenWidth, height: itemHeight)
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if isOverViewButtonSelected{
            return 10
        }else{
            return 0
        }
    }
}
extension DetailsViewController : UITextViewDelegate{
    func textViewDidEndEditing(_ textView: UITextView) {
        switch typeOfDetails{
        case .location:
            self.mainView.containerWriteComment.textViewPlaceHolder.isHidden = !textView.text.isEmpty
        case .tour:
            self.tourMainView.containerWriteComment.textViewPlaceHolder.isHidden = !textView.text.isEmpty
        case nil:
            return
        }
    }
    func textViewDidChange(_ textView: UITextView) {
        switch typeOfDetails{
        case .location:
            let currentTextCount = textView.text.count
            let maxTextCount = 50 // Максимальна кількість символів
            self.mainView.containerWriteComment.characterCountLabel.text = "\(currentTextCount)/\(maxTextCount)"
            var height = self.minHeight
            
            if textView.contentSize.height <= self.minHeight {
                height = self.minHeight
            } else if textView.contentSize.height >= self.maxHeight {
                height = self.maxHeight
            } else {
                height = textView.contentSize.height
            }
            
            self.mainView.containerWriteComment.textViewPlaceHolder.isHidden = !textView.text.isEmpty
            self.mainView.containerWriteComment.sendCommentButton.isUserInteractionEnabled = !textView.text.isEmpty
            self.mainView.containerWriteComment.sendCommentButton.layer.borderColor = !textView.text.isEmpty ? UIColor(hexString: "#973939").cgColor : UIColor(hexString: "#973939").withAlphaComponent(0.24).cgColor
            self.mainView.containerWriteComment.sendCommentButton.setTitleColor(!textView.text.isEmpty ? UIColor(hexString: "#973939") : UIColor(hexString: "#973939").withAlphaComponent(0.24) , for: .normal)
            if let oldConstraint = self.mainView.ContainerWriteHeightConstraint{
                oldConstraint.isActive = false
            }
            let newConstraint = self.mainView.containerWriteComment.commentTextView.heightAnchor.constraint(equalToConstant: height)
            newConstraint.isActive = true
            self.scrollView.contentSize = CGSize(width: self.scrollView.bounds.size.width, height: self.calculateContentHeight())
            mainView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: calculateContentHeight())
            
            self.mainView.ContainerWriteHeightConstraint = newConstraint
            UIView.animate(withDuration: 0.1) {
                self.mainView.layoutIfNeeded()
                self.scrollView.layoutIfNeeded()
            }
        case .tour:
            let currentTextCount = textView.text.count
            let maxTextCount = 50 // Максимальна кількість символів
            self.tourMainView.containerWriteComment.characterCountLabel.text = "\(currentTextCount)/\(maxTextCount)"
            var height = self.minHeight
            
            if textView.contentSize.height <= self.minHeight {
                height = self.minHeight
            } else if textView.contentSize.height >= self.maxHeight {
                height = self.maxHeight
            } else {
                height = textView.contentSize.height
            }
            
            self.tourMainView.containerWriteComment.textViewPlaceHolder.isHidden = !textView.text.isEmpty
            self.tourMainView.containerWriteComment.sendCommentButton.isUserInteractionEnabled = !textView.text.isEmpty
            self.tourMainView.containerWriteComment.sendCommentButton.layer.borderColor = !textView.text.isEmpty ? UIColor(hexString: "#973939").cgColor : UIColor(hexString: "#973939").withAlphaComponent(0.24).cgColor
            self.tourMainView.containerWriteComment.sendCommentButton.setTitleColor(!textView.text.isEmpty ? UIColor(hexString: "#973939") : UIColor(hexString: "#973939").withAlphaComponent(0.24) , for: .normal)
            if let oldConstraint = self.tourMainView.ContainerWriteHeightConstraint{
                oldConstraint.isActive = false
            }
            let newConstraint = self.tourMainView.containerWriteComment.commentTextView.heightAnchor.constraint(equalToConstant: height)
            newConstraint.isActive = true
            self.scrollView.contentSize = CGSize(width: self.scrollView.bounds.size.width, height: self.calculateContentHeight())
            tourMainView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: calculateContentHeight())
            
            self.tourMainView.ContainerWriteHeightConstraint = newConstraint
            UIView.animate(withDuration: 0.1) {
                self.tourMainView.layoutIfNeeded()
                self.scrollView.layoutIfNeeded()
            }
        case nil:
            return
        }
        
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // Перевірка, чи текстове поле вже не містить більше 250 символів
        switch typeOfDetails{
        case .location:
            let currentText = textView.text as NSString
            let newText = currentText.replacingCharacters(in: range, with: text)
            let maxTextCount = 50 // Максимальна кількість символів
            let remainingCount = maxTextCount - newText.count
            self.mainView.containerWriteComment.characterCountLabel.text = "\(remainingCount)/\(maxTextCount)"
            return newText.count <= 50
        case .tour:
            let currentText = textView.text as NSString
            let newText = currentText.replacingCharacters(in: range, with: text)
            let maxTextCount = 50 // Максимальна кількість символів
            let remainingCount = maxTextCount - newText.count
            self.tourMainView.containerWriteComment.characterCountLabel.text = "\(remainingCount)/\(maxTextCount)"
            return newText.count <= 50
        case nil:
            return false
            
        }
    }
}
