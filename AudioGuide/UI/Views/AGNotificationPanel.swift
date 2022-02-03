//
//  AGNotificationPanel.swift
//  AudioGuide
//
//  Created by Sergej Bekker on 01.02.2022.
//

import UIKit
import SwiftMessages

@available(iOSApplicationExtension, unavailable)
class AGNotificationPanel: UIView {

    enum NotificationType {
        case error
        case success
    }
    
    private let config: SwiftMessages.Config = {
        var config = SwiftMessages.Config()
        config.presentationStyle = .top
        config.duration = .forever
        config.dimMode = .color(color: UIColor.clear, interactive: false)
        config.preferredStatusBarStyle = .lightContent
        return config
    }()

    var notificationType: NotificationType = .error {
        didSet {
            self.updateNotificationType()
        }
    }
    
    var message: String? {
        didSet {
            self.titleLabel.text = self.message
            self.setNeedsLayout()
        }
    }
    
    var delay: TimeInterval = 3
    var onClose: (() -> Void)?
    
    private let titleLabel = AGLabel()
    private var timer: Timer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    private func setup() {
       
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.addGestureRecognizer(tapGestureRecognizer)
        let swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeGestureRecognizer.direction = .up
        self.addGestureRecognizer(swipeGestureRecognizer)
        
        self.titleLabel.textAlignment = .center
        self.titleLabel.font = UIFont.PoppinsFont(ofSize: 14)
        self.titleLabel.textColor = UIColor.white
        self.titleLabel.lineHeight = 20
        self.titleLabel.numberOfLines = 0
        self.titleLabel.backgroundColor = UIColor(named: "AccentColor") ?? .red
        self.titleLabel.clipsToBounds = true
        self.addSubview(self.titleLabel)
    }
    
    private func clearTimer() {
        if let timer = self.timer {
            timer.invalidate()
        }
        self.timer = nil
    }
    
    private func updateNotificationType() {
        switch self.notificationType {
        case .success:
            self.titleLabel.backgroundColor =  UIColor(named: "DoneColor") ?? .green
        case .error:
            self.titleLabel.backgroundColor = UIColor(named: "AccentColor") ?? .red
        }
        self.setNeedsLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let labelsMaxSize = CGSize(width: self.frame.size.width - 80, height: self.frame.size.height)
        let titleSize = self.titleLabel.sizeThatFits(labelsMaxSize)
        let width = titleSize.width + 20
        let height = titleSize.height + 10
        self.titleLabel.frame = CGRect(x: (self.frame.size.width - width) / 2, y: self.frame.size.height / 2 - height / 2, width: width, height: height)
        self.titleLabel.layer.cornerRadius = titleSize.height > 20 ? 8 : self.titleLabel.frame.height / 2
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height / 4)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        self.hide()
    }
    
    @objc func handleSwipe(_ sender: UISwipeGestureRecognizer? = nil) {
        self.hide()
    }
    
    func show() {
        SwiftMessages.show(config: self.config, view: self)
        self.clearTimer()
        self.timer = Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { timer in
            self.hide()
        }
    }

    func hide() {
       self.clearTimer()
       self.onClose?()
       SwiftMessages.hide()
    }

}
