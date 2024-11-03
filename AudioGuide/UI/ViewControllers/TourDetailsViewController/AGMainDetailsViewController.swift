//
//  AGTourDetailsViewController.swift
//  AudioGuide
//
//  Created by Sergej Bekker on 23.02.2022.
//

import UIKit
import SkeletonView
import FloatingPanel
enum DetailsType{
    case location
    case tour
}
class AGMainDetailsViewController: AGViewController {
    let apiCall = APIManager.shared
    private var choosedItemID : Int?
    private let itemImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "tourImage")
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .black
        return imageView
    }()
    let buttonBackgroundView : UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .systemChromeMaterialDark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.clipsToBounds = true
        blurView.layer.cornerRadius = 10
        return blurView
    }()
    private let backBtn : UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "Left"), for: .normal)
        btn.backgroundColor = .clear
        btn.layer.cornerRadius = 10
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    private let addFavouriteBtn : UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "Heart"), for: .normal)
        btn.backgroundColor = .black.withAlphaComponent(0.3)
        btn.layer.cornerRadius = 10
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    let height : CGFloat = 49.0
    var locationDetailsVC : DetailsViewController?
    private let noAccountPopUp = NoAccountPopUp()
    private lazy var fpc : FloatingPanelController = {
        let panel = FloatingPanelController(delegate: self)
        panel.layout = MyFloatingPanelLayout()
        panel.contentMode = .static
        return panel
    }()
    private var audios : [OneTourAudio] = []
    private lazy var fpcPlayer = BaseBottomSheetController()
    private lazy var buyListenButton : UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("Buy this audio for 7.99$", for: .normal)
        btn.backgroundColor = UIColor(hexString: "#973939")
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.titleLabel?.font = .PoppinsFont(ofSize: 17, weight: .semibold)
        btn.layer.cornerRadius = 10
        return btn
    }()
    private let typeOfDetails : DetailsType?
    init(with choosedLocationID: Int,typeOfDetail : DetailsType){
        self.choosedItemID = choosedLocationID // Передаємо дані контролеру
        self.typeOfDetails = typeOfDetail
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        cancelsEditingByBackgroundTap = true
        setUpUIElements()
        backBtn.addTarget(self, action: #selector(didTapBackBtn), for: .touchUpInside)
        addNoAccountPopUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.setUpSkelletonView()
        }
        if let customNavigationController = self.navigationController as? CustomNavigationController {
            // Приховуємо кастомний навігаційний бар
            customNavigationController.customNavigationBar.isHidden = true // або false для показу
        }
        guard let idDevice = UserDefaults.standard.value(forKey: "id_device") as? String, let id = choosedItemID else{
            return
        }
        print("idDevice : \(idDevice)\nid : \(id)")
        print("Type \(String(describing: typeOfDetails))")
        if typeOfDetails == .location{
            apiCall.fetchOneLocationData(idDevice: idDevice, id: id){ result in
                switch result {
                case .success(let oneLocationResponce):
                    let pointId = oneLocationResponce.data.data.id
                    let type = oneLocationResponce.data.message
                    let rate = 4 //MARK: Коли буде рейтинг в апі змінити цейу рядок
                    let title = oneLocationResponce.data.data.pointLangData.first?.name
                    let duration = oneLocationResponce.data.data.tours.first?.duration
                    let adress = oneLocationResponce.data.data.pointLangData.first?.address
                    let description = oneLocationResponce.data.data.pointLangData.first?.description
                    let tours = oneLocationResponce.data.data.tours
                    let toursEmptyOrNot : Bool = tours.isEmpty
                    var newTours : [AudioTour] = []
                    if !toursEmptyOrNot{
                        for tour in tours {
                            newTours.append(AudioTour(id: tour.id, name: tour.toursLangData.first!.name, duration: tour.duration, distance: tour.distance, price: "$15.00", photoName: tour.img))
                        }
                    }
                    let locationImg = "https://devapi.test.vn.ua/storage/" + oneLocationResponce.data.data.img
                    if let url = URL(string: locationImg){
                        self.itemImageView.sd_setImage(with: url)
                    }
                    let comments = oneLocationResponce.data.data.comments
                    var usersComments :[UsersComments] = []
                    for comment in comments{
                        usersComments.append(UsersComments(id: comment.id, idPointOrTour: comment.idPoint, idUser: comment.idUser, comment: comment.comment, active: comment.active, createdAt: comment.createdAt, updatedAt: comment.updatedAt, rating: comment.rating, userData: comment.userData))
                    }
                    DispatchQueue.main.async{
                        self.locationDetailsVC = DetailsViewController(withType: .location, id: pointId, type: type, rate: rate, title: title, duration: duration, street: adress, description: description, tours: newTours, comments: usersComments, isTourEmpty: toursEmptyOrNot)
                        self.setUpBottomSheet()
                        self.itemImageView.hideSkeleton()
                        self.itemImageView.stopSkeletonAnimation()
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.itemImageView.hideSkeleton()
                        self.itemImageView.stopSkeletonAnimation()
                    }
                    print("Enter Error : \(error.localizedDescription)")
                    switch (error as NSError).code{
                    case 404:
                        print("No data found : \(error.localizedDescription)")
                    case 500 :
                        print("500 server code to get one location : \(error.localizedDescription)")
                    default :
                        print("Location HZ")
                    }
                }
            }
        }else{
            apiCall.fetchOneTourData(idDevice: idDevice, id: id) { result in
                switch result {
                case .success(let oneTourResponce):
                    let tourId = oneTourResponce.data.data.tourInfo.id
                    let type = oneTourResponce.data.message
                    let rate = oneTourResponce.data.data.tourInfo.rating
                    let title = oneTourResponce.data.data.tourInfo.toursLangData.first?.name
                    let duration = oneTourResponce.data.data.tourInfo.duration
                    let distance = oneTourResponce.data.data.tourInfo.duration
                    //                let adress = oneTourResponce.data.data.data.
                    let oneTourAudio = oneTourResponce.data.data.tourPoints.compactMap{$0.audio}
                    // Перетворюємо двовимірний масив на одновимірний
                    let flattenedArray = oneTourAudio.flatMap { $0 }
                    print("flattenedArray: \(flattenedArray)")
                    self.audios = flattenedArray
                    let description = oneTourResponce.data.data.tourInfo.toursLangData.first?.description
                    let pointsInTour = oneTourResponce.data.data.tourPoints
                    let pointsEmptyOrNot : Bool = pointsInTour.isEmpty
                    var newPointsInTours : [Location] = []
                    if !pointsEmptyOrNot{
                        for point in pointsInTour {
                            newPointsInTours.append(Location(name: point.pointLangData.first?.name ?? "No title", street: point.pointLangData.first?.address ?? "No adress", photoName: "https://devapi.test.vn.ua/storage/" + point.img, id: point.id))
                        }
                    }
                    let locationImg = "https://devapi.test.vn.ua/storage/" + oneTourResponce.data.data.tourInfo.img
                    if let url = URL(string: locationImg){
                        self.itemImageView.sd_setImage(with: url)
                    }
                    let comments = oneTourResponce.data.data.tourInfo.comments
                    var usersComments :[UsersComments] = []
                    for comment in comments{
                        usersComments.append(UsersComments(id: comment.id, idPointOrTour: comment.idTour, idUser: comment.idUser, comment: comment.comment, active: comment.active, createdAt: comment.createdAt, updatedAt: comment.updatedAt, rating: comment.rating, userData: comment.userData))
                    }
                    DispatchQueue.main.async{
                        self.locationDetailsVC = DetailsViewController(withType : .tour, id: tourId, type: type, rate: rate, title: title, duration: duration, description: description, points: newPointsInTours, comments: usersComments, isPointsEmpty: pointsEmptyOrNot)
                        self.setUpBottomSheet()
                        self.itemImageView.hideSkeleton()
                        self.itemImageView.stopSkeletonAnimation()
                    }
                case .failure(let failure):
                    print("Fail to get one tour info")
                    DispatchQueue.main.async {
                        self.itemImageView.hideSkeleton()
                        self.itemImageView.stopSkeletonAnimation()
                    }
                    print("Enter Error : \(failure.localizedDescription)")
                    switch (failure as NSError).code{
                    case 404:
                        print("No tour data found : \(failure.localizedDescription)")
                    default : print("500 server code to get one tour : \(failure.localizedDescription)")
                    }
                }
            }
        }
    }
    private func addNoAccountPopUp(){
        noAccountPopUp.alpha = 0
        noAccountPopUp.tryAgainButton.addTarget(self, action: #selector(tapRegisterAccount), for: .touchUpInside)
        noAccountPopUp.isHidden = true
        
        if let tabBarController = self.tabBarController {
        tabBarController.view.addSubview(noAccountPopUp)
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
    private func setUpSkelletonView(){
        itemImageView.isSkeletonable = true
        itemImageView.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .systemGray3, secondaryColor: .systemGray6), animation: nil, transition: .crossDissolve(0.25))
    }
    @objc private func didTapBackBtn(){
        print("Tapped didTapBackBtn")
        navigationController?.popViewController(animated: true)
    }
    private func setUpUIElements(){
        view.addSubview(itemImageView)
        view.addSubview(buttonBackgroundView)
        buttonBackgroundView.contentView.addSubview(backBtn)
        view.addSubview(addFavouriteBtn)
        NSLayoutConstraint.activate([
            itemImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            itemImageView.topAnchor.constraint(equalTo: view.topAnchor),
            itemImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            itemImageView.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.size.height / 2) + 50),
            
            buttonBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 16),
            buttonBackgroundView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 16),
            buttonBackgroundView.heightAnchor.constraint(equalToConstant: 32),
            buttonBackgroundView.widthAnchor.constraint(equalToConstant: 32),
            
            backBtn.leadingAnchor.constraint(equalTo: buttonBackgroundView.contentView.leadingAnchor),
            backBtn.topAnchor.constraint(equalTo: buttonBackgroundView.contentView.topAnchor),
            backBtn.trailingAnchor.constraint(equalTo: buttonBackgroundView.contentView.trailingAnchor),
            backBtn.bottomAnchor.constraint(equalTo: buttonBackgroundView.contentView.bottomAnchor),
            
            addFavouriteBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -16),
            addFavouriteBtn.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 16),
            addFavouriteBtn.heightAnchor.constraint(equalToConstant: 32),
            addFavouriteBtn.widthAnchor.constraint(equalToConstant: 32),
        ])
        buttonBackgroundView.layer.cornerRadius = 10
        addFavouriteBtn.addTarget(self, action: #selector(didtapSaveTofavourite), for: .touchUpInside)
    }
    @objc private func didtapSaveTofavourite(){
        if let isFreeVersion = UserDefaults.isFreeVersion{
            if isFreeVersion{
                guideCellDidTapLikeButton()
            }else{
                //MARK: зберігаємо в юлюблені
            }
        }
    }
    private func guideCellDidTapLikeButton() {
        DispatchQueue.main.async {
            self.noAccountPopUp.isHidden = false
            UIView.animate(withDuration: 0.3) {
                self.noAccountPopUp.alpha = 1.0
            }
        }
    }
    private func setUpBottomSheet(){
        guard let vc = locationDetailsVC else {
            return
        }
        fpc.set(contentViewController: vc)
        fpc.track(scrollView: vc.scrollView)
        fpc.isRemovalInteractionEnabled = false
        fpc.addPanel(toParent: self)
        view.addSubview(buyListenButton)
        
        NSLayoutConstraint.activate([
            buyListenButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            buyListenButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            buyListenButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            buyListenButton.heightAnchor.constraint(equalToConstant: 39),
        ])
//        vc.isModalInPresentation = true
//
//        if let sheet = vc.sheetPresentationController {
//            sheet.detents = [.medium(), .custom(resolver: { context in
//                0.85 * context.maximumDetentValue
//            })]
//            sheet.largestUndimmedDetentIdentifier = .large
//            sheet.prefersGrabberVisible = true // Додайте цей рядок, щоб показати "граббер"
//            sheet.applyBottomSheetStyle(withHeight: height)
//            self.view.layoutIfNeeded()
//        }
//        present(vc, animated: true)
        
        buyListenButton.addTarget(self, action: #selector(didTapShowPlayer), for: .touchUpInside)
    }
    @objc private func didTapShowPlayer(){
        prepareDiagnoseBottomSheet()
    }
    private func prepareDiagnoseBottomSheet() {
        let diagnoseBottomContent = PlayerAudioViewController()
        diagnoseBottomContent.audios = audios
        diagnoseBottomContent.delegate = self
        diagnoseBottomContent.toggleStateHandler = { [weak self] in
            self?.fpcPlayer.toggleFloatingPanelState()
            }
        let diagnoseBottomSheetDelegateController = DiagnoseBottomSheetDelegateController(vc: diagnoseBottomContent)
        fpcPlayer.setupBottomSheet(contentVC: diagnoseBottomContent, floatingPanelDelegate: diagnoseBottomSheetDelegateController, addToParrent: self)
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        hideBottomSheet()
    }
}
extension AGMainDetailsViewController : FloatingPanelControllerDelegate{

}
extension AGMainDetailsViewController : DidHideAudioPlaylist{
    func movePanelTo(position: DiagnoseViewTypes) {
        switch position {
        case .half:
            fpcPlayer.moveBottomSheet(to: .half, animated: true)
        case .full:
            fpcPlayer.moveBottomSheet(to: .full, animated: true)
        }
        
    }
}
class MyFloatingPanelLayout: FloatingPanelLayout {
    let position: FloatingPanelPosition = .bottom
    let initialState: FloatingPanelState = .half
    let anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] = [
        .full: FloatingPanelLayoutAnchor(fractionalInset: 0.15, edge: .top, referenceGuide: .safeArea),
        .half: FloatingPanelLayoutAnchor(fractionalInset: 0.5, edge: .bottom, referenceGuide: .safeArea),
    ]
}
//struct Audio {
//    let name : String
//    let typeGuideAudio : String
//    let imageName : UIImage
//    let trackName : String
//}
