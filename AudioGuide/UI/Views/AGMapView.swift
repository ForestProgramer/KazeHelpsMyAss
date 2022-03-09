//
//  AGMapView.swift
//  AudioGuide
//
//  Created by Sergej Bekker on 04.02.2022.
//

import Foundation
import UIKit
import GoogleMaps
import GooglePlaces
import GoogleMapsUtils
import NoticeObserveKit

enum MarkerType {
    case MUSEUM
    case PARKING
    case HISTORY
}

class AGGMSMarker: GMSMarker {
    
    var type: MarkerType = .HISTORY
    var isSelect: Bool = false {
        didSet {
            self.imageView.image = #imageLiteral(resourceName: "parking_pin_icon")
            self.view.frame = CGRect(x: 0, y: 0, width: 32, height: 46)
            if type == .HISTORY {
                self.view.frame = CGRect(x: 0, y: 0, width: 88, height: 58)
                self.imageView.image = #imageLiteral(resourceName: "history_pin_icon")
            } else if type == .MUSEUM {
                self.imageView.image = #imageLiteral(resourceName: "musem_pin_icon")
            }
            if self.isSelect {
                self.view.frame = CGRect(x: 0, y: 0, width: 44, height: 63)
                if type == .HISTORY {
                    self.view.frame = CGRect(x: 0, y: 0, width: 110, height: 73)
                }
            }
            self.imageView.frame = view.frame
            self.iconView = self.view
        }
    }
    var iconImage: UIImage? {
        didSet {
            if let iconImage = iconImage {
                self.imageView.image = iconImage
                if self.isSelect {
                }
                self.iconView = self.view
            }
        }
    }
    
    private var view = UIView(frame: CGRect(x: 0, y: 0, width: 32, height: 46))
    private var imageView = UIImageView()
    private var durationLabel = UILabel()
    private let pool = NoticeObserverPool()

    required override init() {
        super.init()
    }

    convenience init(type: MarkerType, userData: String? = nil) {
        self.init()
        self.imageView.image = #imageLiteral(resourceName: "parking_pin_icon")
        self.position  = CLLocationCoordinate2D(latitude: AGMapView.currentLoacation.latitude, longitude:  AGMapView.currentLoacation.longitude)
        if type == .HISTORY {
            self.view.frame = CGRect(x: 0, y: 0, width: 88, height: 58)
            self.imageView.image = #imageLiteral(resourceName: "history_pin_icon")
        } else if type == .MUSEUM {
            self.imageView.image = #imageLiteral(resourceName: "musem_pin_icon")
        }
        if isSelect {
            self.view.frame = CGRect(x: 0, y: 0, width: 44, height: 63)
            if type == .HISTORY {
                self.view.frame = CGRect(x: 0, y: 0, width: 110, height: 73)
            }
        }
        self.imageView.frame = view.frame
        self.view.addSubview(self.imageView)
        self.iconView = self.view
    }
    
    convenience init(maker: AGGMSMarker) {
        self.init()
        self.imageView.image = #imageLiteral(resourceName: "parking_pin_icon")
        self.position  = CLLocationCoordinate2D(latitude: AGMapView.currentLoacation.latitude, longitude:  AGMapView.currentLoacation.longitude)
        if type == .HISTORY {
            self.view.frame = CGRect(x: 0, y: 0, width: 88, height: 58)
            self.imageView.image = #imageLiteral(resourceName: "history_pin_icon")
        } else if type == .MUSEUM {
            self.imageView.image = #imageLiteral(resourceName: "musem_pin_icon")
        }
        if isSelect {
            self.view.frame = CGRect(x: 0, y: 0, width: 44, height: 63)
            if type == .HISTORY {
                self.view.frame = CGRect(x: 0, y: 0, width: 110, height: 73)
            }
        }
        self.imageView.frame = view.frame
        self.view.addSubview(self.imageView)
        self.iconView = self.view
    }
    
}
class AGMapView: GMSMapView {

    var markers = [AGGMSMarker]()
    var tapAction: (() -> Void)?
    var tapMaker: (() -> Void)?
    
    private var selectMarker: AGGMSMarker?
    private var isMyLocation: Bool = false
    static var currentLoacation = CLLocationCoordinate2D(latitude: 46.679559469167465, longitude: 30.646260262362055)
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.initMap()
    }
    
    private func initMap() {

        AGMapView.currentLoacation.latitude = 46.679559469167465
        AGMapView.currentLoacation.longitude = 30.646260262362055
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//            var marker = AGGMSMarker(type: .HISTORY)
//            self.addMarker(marker: marker)
//        }
       
        
//        marker = AGGMSMarker(type: .MUSEUM)
//        self.addMarker(marker: marker)
//        marker = AGGMSMarker(type: .HISTORY)
//        self.addMarker(marker: marker)
        
        self.delegate = self
//        let iconGenerator = GMUDefaultClusterIconGenerator()
//        let algorithm = GMUNonHierarchicalDistanceBasedAlgorithm()
//        let renderer = GMUDefaultClusterRenderer(mapView: self, clusterIconGenerator: iconGenerator)
//        renderer.delegate = self
//        self.clusterManager = GMUClusterManager(map: self, algorithm: algorithm, renderer: renderer)
        self.mapType = .normal
        self.isBuildingsEnabled = true
        self.isIndoorEnabled = true
        self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.isMyLocationEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AGMapView.handleTap( _:)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        self.addGestureRecognizer(tapGestureRecognizer)
        self.addObserver(self, forKeyPath: "myLocation", options: .new, context: nil)
        self.clear()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if  change?[NSKeyValueChangeKey.oldKey] == nil && !self.isMyLocation {
            self.isMyLocation = true
            // Initialize the location manager.
            if let location = change?[NSKeyValueChangeKey.newKey] as? CLLocation {
                AGMapView.currentLoacation = location.coordinate
                let marker = AGGMSMarker(type: .HISTORY)
                self.addMarker(marker: marker)
                self.camera = GMSCameraPosition.camera(withTarget: location.coordinate, zoom: 4)
            }
        }
    }
    
    private func addMarker(marker: AGGMSMarker) {
        let marker = AGGMSMarker(type: marker.type)
        marker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
        marker.map = self
        self.markers.append(marker)
        //self.clusterManager?.add(marker)
    }
    
    private func removeMarkers(){
        for (idx, marker) in self.markers.enumerated() {
            marker.isSelect = false
            self.markers[idx].map = nil
        }
        //self.clusterManager?.clearItems()
    }
    
    private func selectMarkerOnMap(marker: GMSMarker?) {
        guard let marker = marker as? AGGMSMarker else { return }
        var point = self.projection.point(for: marker.position)
        marker.isSelect = true
        self.selectMarker = marker
        point.y += 100
        self.selectedMarker = marker
        let newPoint = self.projection.coordinate(for: point)
        let camera = GMSCameraUpdate.setTarget(newPoint)
        self.animate(with: camera)
    }
    
    @objc private func handleTap(_ gestureReconizer: UITapGestureRecognizer) {
        self.tapAction?()
    }
}

extension AGMapView: GMUClusterRendererDelegate {
    func renderer(_ renderer: GMUClusterRenderer, markerFor object: Any) -> GMSMarker? {
        switch object {
        case let clusterItem as AGGMSMarker:
            return AGGMSMarker(maker: clusterItem)
        default:
            return nil
        }
    }
}

extension AGMapView: GMUClusterManagerDelegate {
    func clusterManager(_ clusterManager: GMUClusterManager, didTap cluster: GMUCluster) -> Bool {
        print("tap cluster")
        return false
    }
    
    func clusterManager(_ clusterManager: GMUClusterManager, didTap clusterItem: GMUClusterItem) -> Bool {
        print("tap cluster item")
        return false
    }
}


// MARK: - GMSMapView view delegate -

extension AGMapView: GMSMapViewDelegate {

    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {

    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {

    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        for marker in self.markers {
            marker.isSelect = false
        }
        self.tapAction?()
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        self.selectMarker = marker as? AGGMSMarker
        self.selectMarkerOnMap(marker: marker)
        self.tapMaker?()
        return true
    }
}
