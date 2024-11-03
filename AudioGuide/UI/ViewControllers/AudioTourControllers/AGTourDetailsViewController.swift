//
//  AudioDetailsViewController.swift
//  AudioGuide
//
//  Created by Максим Оліярник on 13.10.2023.
//

import UIKit
import FloatingPanel
class AGTourDetailsViewController: AGViewController {
    let apiCall = APIManager.shared
    private var choosedLocationID : Int?
    private let tourImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "tourImage")
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .black
        return imageView
    }()
    private let backBtn : UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "Left"), for: .normal)
        btn.backgroundColor = .black.withAlphaComponent(0.3)
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
    var locationDetailsVC : TourDetailsViewController?
    private lazy var fpc : FloatingPanelController = {
        let panel = FloatingPanelController(delegate: self)
        panel.layout = MyFloatingPanelLayout()
        panel.contentMode = .static
        return panel
    }()
    private lazy var buyListenButton : UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("Buy this audio for 7.99$", for: .normal)
        btn.backgroundColor = UIColor(hexString: "#973939")
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.titleLabel?.font = .PoppinsFont(ofSize: 17, weight: .semibold)
        btn.layer.cornerRadius = 10
        return btn
    }()
    init(with choosedLocationID: Int){
        self.choosedLocationID = choosedLocationID // Передаємо дані контролеру
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        cancelsEditingByBackgroundTap = true
        setUpUIElements()
        backBtn.addTarget(self, action: #selector(didTapBackBtn), for: .touchUpInside)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.setUpSkelletonView()
        }
        if let customNavigationController = self.navigationController as? CustomNavigationController {
            // Приховуємо кастомний навігаційний бар
            customNavigationController.customNavigationBar.isHidden = true // або false для показу
        }
        guard let idDevice = UserDefaults.standard.value(forKey: "id_device") as? String, let id = choosedLocationID else{
            return
        }
        print("idDevice : \(idDevice)\nid : \(id)")
        
    }
    private func setUpSkelletonView(){
        tourImageView.isSkeletonable = true
        tourImageView.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .systemGray3, secondaryColor: .systemGray6), animation: nil, transition: .crossDissolve(0.25))
    }
    @objc private func didTapBackBtn(){
        print("Tapped didTapBackBtn")
        navigationController?.popViewController(animated: true)
    }
    func setupStaticButton() {
        let staticButton = UIButton(type: .system)
        staticButton.setTitle("Static Button", for: .normal)
        staticButton.frame = CGRect(x: 50, y: 800, width: 150, height: 50) // Приклад розташування кнопки
        
        // Додавання обробника події кнопки
//        staticButton.addTarget(self, action: #selector(staticButtonTapped), for: .touchUpInside)
        
        // Додавання кнопки на батьківську в'ю контролера
        view.addSubview(staticButton)
    }
    private func setUpUIElements(){
        view.addSubview(tourImageView)
        view.addSubview(backBtn)
        view.addSubview(addFavouriteBtn)
        NSLayoutConstraint.activate([
            tourImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tourImageView.topAnchor.constraint(equalTo: view.topAnchor),
            tourImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tourImageView.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.size.height / 2) + 50),
            
            backBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 16),
            backBtn.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 16),
            backBtn.heightAnchor.constraint(equalToConstant: 32),
            backBtn.widthAnchor.constraint(equalToConstant: 32),
            
            addFavouriteBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -16),
            addFavouriteBtn.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 16),
            addFavouriteBtn.heightAnchor.constraint(equalToConstant: 32),
            addFavouriteBtn.widthAnchor.constraint(equalToConstant: 32),
        ])
        
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
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        hideBottomSheet()
    }
}
extension AGTourDetailsViewController : FloatingPanelControllerDelegate{

}
class MyTourFloatingPanelLayout: FloatingPanelLayout {
    let position: FloatingPanelPosition = .bottom
    let initialState: FloatingPanelState = .half
    let anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] = [
        .full: FloatingPanelLayoutAnchor(fractionalInset: 0.15, edge: .top, referenceGuide: .safeArea),
        .half: FloatingPanelLayoutAnchor(fractionalInset: 0.5, edge: .bottom, referenceGuide: .safeArea),
    ]
}
