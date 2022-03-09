//
//  AGARVIew.swift
//  AudioGuide
//
//  Created by Sergej Bekker on 03.02.2022.
//

import UIKit
import ARKit
import SceneKit
import CoreLocation

class AGARVIew: UIView {

    @IBOutlet weak var sceneView: ARSCNView!
    
    var tapMaker: (() -> Void)?
    
    private let locationManager = CLLocationManager()
    private var userLocation = CLLocation()
    private var modelNode:SCNNode!
    private let modelScene = SCNScene()
    private var plane = SCNPlane()
    private let rootNodeName = "Node"
    private var distance : Float = 0.0
    private var isPresent = false
    private var heading : Double = 0.0
    private var originalTransform:SCNMatrix4!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
       
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
    }
    
    private func setup() {
        self.sceneView.delegate = self
        let scene = SCNScene()
        self.modelNode = self.modelScene.rootNode
        self.sceneView.scene = scene
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AGARVIew.handleTap( _:)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func updateLocation(_ latitude : Double, _ longitude : Double) {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        self.distance = Float(location.distance(from: self.userLocation))
        
        if !self.isPresent {
            self.isPresent = true
            let minVec = modelNode.boundingBox.min
            let maxVec = modelNode.boundingBox.max
            let bound = SCNVector3Make(maxVec.x - minVec.x,
                                       maxVec.y - minVec.y,
                                       maxVec.z - minVec.z);
            let view = UIView(frame: CGRect(x: 0, y: 0, width: 165, height: 48))
            view.backgroundColor = .white
            let imageView = UIImageView(frame:  view.frame)
            imageView.image = UIImage(named: "AR Marker")
            view.addSubview(imageView)
    
            plane.width = CGFloat(bound.x + 2.5)
            plane.height = CGFloat(bound.y + 0.7)
            plane.cornerRadius = 0.1
            plane.firstMaterial!.diffuse.contents = UIColor.white.cgColor
            //plane.firstMaterial!.diffuse.contents = "⬇️".image()!
            plane.firstMaterial!.diffuse.contents = view
            let node = SCNNode(geometry: plane)
            node.constraints = [SCNBillboardConstraint()]
            // Create arrow from the emoji
//            let arrow = makeBillboardNode("⬇️".image()!)
//            // Position it on top of the car
//            arrow.position = SCNVector3Make(0, 0, 0)
//            // Add it as a child of the car model
//            node.addChildNode(arrow)
            self.modelNode.addChildNode(node)
        
            
            // Move model's pivot to its center in the Y axis
            let (minBox, maxBox) = self.modelNode.boundingBox
            self.modelNode.pivot = SCNMatrix4MakeTranslation(0, (maxBox.y - minBox.y)/2, 0)
            
            // Save original transform to calculate future rotations
            self.originalTransform = self.modelNode.transform
            
            // Position the model in the correct place
            positionModel(location)
            
            // Add the model to the scene
            self.sceneView.scene.rootNode.addChildNode(self.modelNode)
        } else {
            // Begin animation
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 1.0

            // Position the model in the correct place
            positionModel(location)

            // End animation
            SCNTransaction.commit()
        }
    }
    
    private func positionModel(_ location: CLLocation) {
        // Rotate node
        self.modelNode.transform = rotateNode(Float(-1 * (self.heading - 180).toRadians()), self.originalTransform)
        
        // Translate node
        self.modelNode.position = translateNode(location)
        
        // Scale node
        self.modelNode.scale = scaleNode(location)
    }
    
    private func rotateNode(_ angleInRadians: Float, _ transform: SCNMatrix4) -> SCNMatrix4 {
        let rotation = SCNMatrix4MakeRotation(angleInRadians, 0, 1, 0)
        return SCNMatrix4Mult(transform, rotation)
    }
    
    private func translateNode (_ location: CLLocation) -> SCNVector3 {
        let locationTransform = transformMatrix(matrix_identity_float4x4, userLocation, location)
        return positionFromTransform(locationTransform)
    }
    
    private func scaleNode (_ location: CLLocation) -> SCNVector3 {
        let scale = max( min( Float(1000/distance), 1.5 ), 3 )
        return SCNVector3(x: scale, y: scale, z: scale)
    }
    
    private func positionFromTransform(_ transform: simd_float4x4) -> SCNVector3 {
        return SCNVector3Make(transform.columns.3.x, transform.columns.3.y, transform.columns.3.z)
    }
    
    private func transformMatrix(_ matrix: simd_float4x4, _ originLocation: CLLocation, _ driverLocation: CLLocation) -> simd_float4x4 {
        let bearing = bearingBetweenLocations(userLocation, driverLocation)
        let rotationMatrix = rotateAroundY(matrix_identity_float4x4, Float(bearing))
        
        let position = vector_float4(0.0, 0.0, -distance, 0.0)
        let translationMatrix = getTranslationMatrix(matrix_identity_float4x4, position)
        
        let transformMatrix = simd_mul(rotationMatrix, translationMatrix)
        
        return simd_mul(matrix, transformMatrix)
    }
    
    private func getTranslationMatrix(_ matrix: simd_float4x4, _ translation : vector_float4) -> simd_float4x4 {
        var matrix = matrix
        matrix.columns.3 = translation
        return matrix
    }
    
    private func rotateAroundY(_ matrix: simd_float4x4, _ degrees: Float) -> simd_float4x4 {
        var matrix = matrix
        
        matrix.columns.0.x = cos(degrees)
        matrix.columns.0.z = -sin(degrees)
        
        matrix.columns.2.x = sin(degrees)
        matrix.columns.2.z = cos(degrees)
        return matrix.inverse
    }
    
    private func bearingBetweenLocations(_ originLocation: CLLocation, _ driverLocation: CLLocation) -> Double {
        let lat1 = originLocation.coordinate.latitude.toRadians()
        let lon1 = originLocation.coordinate.longitude.toRadians()
        
        let lat2 = driverLocation.coordinate.latitude.toRadians()
        let lon2 = driverLocation.coordinate.longitude.toRadians()
        
        let longitudeDiff = lon2 - lon1
        
        let y = sin(longitudeDiff) * cos(lat2);
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(longitudeDiff);
        
        return atan2(y, x)
    }
    
    private func makeBillboardNode(_ image: UIImage) -> SCNNode {
        let plane = SCNPlane(width: 10, height: 10)
        plane.firstMaterial!.diffuse.contents = image
        let node = SCNNode(geometry: plane)
        node.constraints = [SCNBillboardConstraint()]
        return node
    }
    
    @objc private func handleTap(_ gestureReconizer: UITapGestureRecognizer) {
        self.tapMaker?()
    }
    
    //MARK: - CLLocationManager

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            userLocation = location
            self.updateLocation(46.57827211617446, 30.79216138097019)
        }
    }
}

extension AGARVIew: ARSCNViewDelegate, CLLocationManagerDelegate {
    
}

