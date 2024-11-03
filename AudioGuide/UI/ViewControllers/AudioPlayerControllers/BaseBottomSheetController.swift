//
//  BaseBottomSheetController.swift
//  AudioGuide
//
//  Created by Максим Оліярник on 10.04.2024.
//

import UIKit
import FloatingPanel
class BaseBottomSheetController: UIViewController {
    private var fpc = FloatingPanelController()
    private var floatingPanelDelegate: FloatingPanelControllerDelegate? {
        didSet {
            fpc.delegate = floatingPanelDelegate
        }
    }
    public var currentPanelState: FloatingPanelState {
            return fpc.state
        }
    func toggleFloatingPanelState() {
        if fpc.state == .half {
            fpc.move(to: .full, animated: true)
        } else {
            fpc.move(to: .half, animated: true)
        }
    }
    func setupBottomSheet(contentVC: UIViewController?, floatingPanelDelegate: FloatingPanelControllerDelegate,addToParrent controller : UIViewController) {
        self.floatingPanelDelegate = floatingPanelDelegate
        prepareDiagnoseBottomSheet(contentVC: contentVC, mainViewController: controller)
    }
    private func prepareDiagnoseBottomSheet(contentVC: UIViewController?,mainViewController : UIViewController) {
        fpc.surfaceView.appearance.cornerRadius = 10
        fpc.surfaceView.grabberHandle.isHidden = true
        fpc.surfaceView.backgroundColor = .clear
        fpc.contentMode = .fitToBounds
        fpc.set(contentViewController: contentVC)
        fpc.addPanel(toParent: mainViewController)
        fpc.isRemovalInteractionEnabled = false
    }
    public func moveBottomSheet(to state : FloatingPanelState, animated : Bool){
        fpc.move(to: state, animated: animated)
    }
}
class DiagnoseBottomSheetDelegateController: FloatingPanelControllerDelegate {
    weak var contentVC: PlayerAudioViewController?
    
    init(vc: PlayerAudioViewController) {
        self.contentVC = vc
    }
    func floatingPanel(_ fpc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout {
        return FloatingPanelStocksLayout()
    }
    func floatingPanelDidChangeState(_ vc: FloatingPanelController) {
        switch vc.state {
        case .half:
            contentVC?.updateView(viewType: .half)
        case .full:
            contentVC?.updateView(viewType: .full)
        default:
            return
        }
    }
}
class FloatingPanelStocksLayout: FloatingPanelLayout {
    let position: FloatingPanelPosition = .bottom
    let initialState: FloatingPanelState = .half
    let anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] = [
        .full: FloatingPanelLayoutAnchor(fractionalInset: 0, edge: .top, referenceGuide: .superview),
        .half: FloatingPanelLayoutAnchor(fractionalInset: 0.269, edge: .bottom, referenceGuide: .safeArea),
    ]
    func backdropAlpha(for state: FloatingPanelState) -> CGFloat {
        switch state {
        case .full:
            return 0.0
        default:
            return 0.0
        }
    }
}
