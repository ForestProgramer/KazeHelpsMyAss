//
//  TourDetailsViewController.swift
//  AudioGuide
//
//  Created by Максим Оліярник on 27.03.2024.
//

import UIKit

class TourDetailsViewController: UIViewController {
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = true
//        scrollView.translatesAutoresizingMaskIntoConstraints = falsed
        scrollView.showsVerticalScrollIndicator = true
        scrollView.isDirectionalLockEnabled = false
        return scrollView
    }()
    let tourMainView = TourDetailsUIView()
    let isPointsEmpty :Bool?
    var pointInTours : [Location] = []
    var usersReviews : [UsersComments] = []
    let detailsData : (type : String, rate : Int?, title : String?, duration : String?, description: String?, points : [Location])?
    var isOverViewButtonSelected = true
    private let maxHeight: CGFloat = 150
    private let minHeight: CGFloat = 50
    init(type: String, rate: Int?, title: String?, duration: String?, description: String?, points: [Location],comments : [UsersComments], isPointsEmpty : Bool) {
        self.detailsData = (type: type, rate: rate, title: title, duration: duration, description: description, points: points)
        self.isPointsEmpty = isPointsEmpty
        self.usersReviews = comments
        super.init(nibName: nil, bundle: nil)
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setUpConstraints()
    }
    private func setUpTextViewDelegate(){
        tourMainView.containerWriteComment.commentTextView.delegate = self
    }
    private func congigureViewData(){
        
        guard let type = detailsData?.type, let title = detailsData?.title, let description = detailsData?.description, let points = detailsData?.points else{
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
            guard let isToursEmpty = self.isPointsEmpty else{
                return
            }
            if isToursEmpty{
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
        setUpTextViewDelegate()
    }
    private func setUpButtonsSwitch(){
        tourMainView.reviewsBtn.addTarget(self, action: #selector(didTapReviewsBtn), for: .touchUpInside)
        tourMainView.overViewBtn.addTarget(self, action: #selector(didTapOverViewBtn), for: .touchUpInside)
    }
    @objc private func didTapOverViewBtn(){
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
    }
    @objc private func didTapReviewsBtn() {
        if isOverViewButtonSelected {
            self.tourMainView.overViewBtn.titleLabel?.font = UIFont.PoppinsFont(ofSize: 18, weight: .regular)
            self.tourMainView.reviewsBtn.titleLabel?.font = UIFont.PoppinsFont(ofSize: 20, weight: .medium)
            self.tourMainView.reviewsView.isHidden = false
            self.tourMainView.overView.isHidden = true
            self.isOverViewButtonSelected = false
            
           
//            // Оновлення констрейнтів та розмірів після зміни виду
            DispatchQueue.main.async {
                let commentText = "Lorem Ipsum is simply dummy text of the printing and typesetting industry.Lorem Ipsum is simply dummy text of the printing and typesetting industry.Lorem Ipsum is simply dummy text of the printing and typesetting industry."
                let screenWidth = UIScreen.main.bounds.width
//                let screenHeight = UIScreen.main.bounds.height
//                let itemHeightPercentage: CGFloat = 0.122
                let labelWidth = screenWidth - 52
                let labelFont = UIFont.PoppinsFont(ofSize: 12, weight: .regular)
                let commentTextSize = NSString(string: commentText).boundingRect(with: CGSize(width: labelWidth, height: .greatestFiniteMagnitude), options: [.usesLineFragmentOrigin, .usesFontLeading],attributes: [NSAttributedString.Key.font: labelFont], context: nil).size
                let itemHeight = commentTextSize.height + 60
                let estimatedHeigh = itemHeight * CGFloat(self.usersReviews.count)
                if let oldConstraint = self.tourMainView.reviewsCollectionViewHeightConstraint {
                    oldConstraint.isActive = false // Деактивувати старий констрейнт
                }
                let newConstraint = self.tourMainView.reviewsCollectionView.heightAnchor.constraint(equalToConstant: estimatedHeigh)
                newConstraint.isActive = true // Активувати новий констрейнт
                self.tourMainView.reviewsCollectionViewHeightConstraint = newConstraint
                self.tourMainView.reviewsCollectionView.reloadData()
                self.scrollView.contentSize = CGSize(width: self.scrollView.bounds.size.width, height: self.calculateContentHeight())
                self.scrollView.layoutIfNeeded()
            }
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        let height = calculateContentHeight()
        scrollView.contentSize = CGSize(width: scrollView.bounds.size.width, height: height)
        tourMainView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: height)
        tourMainView.overView.frame = CGRect(x: 0, y: 170, width: scrollView.contentSize.width, height: height)
        tourMainView.reviewsView.frame = CGRect(x: 0, y: 170, width: scrollView.contentSize.width, height: height)
    }
    private func calculateContentHeight() -> CGFloat {
        if isOverViewButtonSelected{
            let elementsOffset : CGFloat = isPointsEmpty! ? 110 : 110
            let estimatedHeight = isPointsEmpty! ? tourMainView.typeLabel.frame.size.height + tourMainView.locationTitleLabel.frame.size.height + tourMainView.durationGuideImageView.frame.size.height + tourMainView.overViewBtn.frame.size.height + tourMainView.overviewLabel.frame.size.height  + elementsOffset : tourMainView.typeLabel.frame.size.height + tourMainView.locationTitleLabel.frame.size.height + tourMainView.durationGuideImageView.frame.size.height + tourMainView.overViewBtn.frame.size.height + tourMainView.overviewLabel.frame.size.height + tourMainView.youWillSeeTourLabel.frame.size.height + tourMainView.pointsCollectionView.frame.size.height + elementsOffset
            return estimatedHeight
        }else{
            let elementsOffset : CGFloat = 170
            let writeContainerHeight = tourMainView.containerWriteComment.frame.size.height
            let estimatedHeight = tourMainView.reviewsCollectionView.frame.size.height + writeContainerHeight + elementsOffset
            return estimatedHeight
        }
    }
    private func calculateReviewsContentHeight(with newCollectionViewHeight : CGFloat) -> CGFloat {
       
        let elementsOffset : CGFloat = 110
        let estimatedHeight = tourMainView.typeLabel.frame.size.height + tourMainView.locationTitleLabel.frame.size.height + tourMainView.durationGuideImageView.frame.size.height + tourMainView.overViewBtn.frame.size.height + tourMainView.overviewLabel.frame.size.height + newCollectionViewHeight + elementsOffset
        return estimatedHeight
    }
    private func setUpScrollView(){
        view.addSubview(scrollView) // Додаємо scrollView на view контролера
        scrollView.addSubview(tourMainView)
        DispatchQueue.main.async {
            self.congigureViewData()
        }
    }
    private func setUpCollectionView(){
        tourMainView.pointsCollectionView.delegate = self
        tourMainView.pointsCollectionView.dataSource = self
        tourMainView.pointsCollectionView.register(ResultUICoCollectionViewCell.self, forCellWithReuseIdentifier: "allLocations")
        tourMainView.reviewsCollectionView.delegate = self
        tourMainView.reviewsCollectionView.dataSource = self
        tourMainView.reviewsCollectionView.register(UserReviewsCollectionViewCell.self, forCellWithReuseIdentifier: UserReviewsCollectionViewCell.identifier)
    }

}
extension TourDetailsViewController : UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isOverViewButtonSelected{
            return pointInTours.count
        }else{
            return usersReviews.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isOverViewButtonSelected{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "allLocations", for: indexPath) as? ResultUICoCollectionViewCell else{
                fatalError()
            }
            let point = pointInTours[indexPath.row]
            cell.setup(with: point)
            return cell
        }else{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserReviewsCollectionViewCell.identifier, for: indexPath) as? UserReviewsCollectionViewCell else {
                fatalError()
            }
            let comment = usersReviews[indexPath.item] // Вираховуємо правильний індекс для usersReviews
//            let newComment = OneItemDeatilsComment(id: comment.id, idPoint: comment.idTour, idUser: comment.idUser, comment: comment.comment, active: comment.active, createdAt: comment.createdAt, updatedAt: comment.updatedAt, user: UserCommentInfo(name: "Unknow", avatar: ""))
//            cell.configureReview(with: newComment)
            return cell
        }
        
    }
}
extension TourDetailsViewController : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if isOverViewButtonSelected{
            let layout = UICollectionViewFlowLayout()
            let insets: CGFloat = 32.0
            // Висота екрана айфона помножена на 0.085
            let itemHeight = UIScreen.main.bounds.height * 0.085
            let itemWidth = UIScreen.main.bounds.width - insets
            layout.sectionInset = UIEdgeInsets(top: insets, left: insets, bottom: insets, right: insets)
            return CGSize(width: itemWidth, height: itemHeight)
        }else{
            //            if indexPath.row != 0 {
            let commentText = "Lorem Ipsum is simply dummy text of the printing and typesetting industry.Lorem Ipsum is simply dummy text of the printing and typesetting industry.Lorem Ipsum is simply dummy text of the printing and typesetting industry."
            let screenWidth = UIScreen.main.bounds.width
            //            let screenHeight = UIScreen.main.bounds.height
            //            let itemHeightPercentage: CGFloat = 0.122
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
extension TourDetailsViewController : UITextViewDelegate{
    func textViewDidEndEditing(_ textView: UITextView) {
        self.tourMainView.containerWriteComment.textViewPlaceHolder.isHidden = !textView.text.isEmpty
    }
    func textViewDidChange(_ textView: UITextView) {
        
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
        self.tourMainView.ContainerWriteHeightConstraint = newConstraint
        UIView.animate(withDuration: 0.1) {
            self.tourMainView.layoutIfNeeded()
        }
    }
}
