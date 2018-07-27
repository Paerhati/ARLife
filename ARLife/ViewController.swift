//
//  ViewController.swift
//  ARInstructions
//
//  Created by James Huang on 7/24/18.
//  Copyright © 2018 James Huang. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var sceneInfoView: UIView!
    @IBOutlet weak var sceneInfoLabel: UILabel!
    
    var nodeModel:SCNNode!
    var fileName = "iPhoneCard"
    
    func scaleGrow(node: SCNNode) {
        let growUp = SCNAction.scale(by: 4, duration: 7)
        node.runAction(growUp)
    }
    
    func scaleTreeUp(node: SCNNode) {
        let rotateOnce = SCNAction.rotateBy(x: 0, y: CGFloat(Float.pi), z: 0, duration: 3.4)
        let scaleUp = SCNAction.scale(to: 0.1, duration: 3.0)
        let rotateAndScale = SCNAction.group([rotateOnce, scaleUp])
        node.runAction(rotateAndScale)
    }
    
    func addRotationAnimation(node: SCNNode) {
        let rotateOne = SCNAction.rotateBy(x: 0, y: CGFloat(Float.pi), z: 0, duration: 4.0)
        let hoverUp = SCNAction.moveBy(x: 0, y: 0.2, z: 0, duration: 2.5)
        let hoverDown = SCNAction.moveBy(x: 0, y: -0.2, z: 0, duration: 2.5)
        let hoverSequence = SCNAction.sequence([hoverUp, hoverDown])
        let rotateAndHover = SCNAction.group([rotateOne, hoverSequence])
        let repeatIndefinitely = SCNAction.repeatForever(rotateAndHover)
        node.runAction(repeatIndefinitely)
    }
    
    func addRotation(x: Float, y: Float, z: Float, node: SCNNode) {
        guard let fortuneCookieScene = SCNScene(named: "fortunecookie.scn"), let fortuneCookieNode = fortuneCookieScene.rootNode.childNode(withName: "fortuneCookie", recursively: true) else { return }
        fortuneCookieNode.position = SCNVector3(x, y, z)
        addRotationAnimation(node: fortuneCookieNode)
        node.addChildNode(fortuneCookieNode)
    }
    
//    func
//
//    func createReviewCard(x: Float, Y: Float, Z: Float) {
//        let reviewCardScene = SKScene(size: CGSize)
//    }
//
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information  along with other timing related functions. Show World origin so that we kno where things begin.
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        resetTrackingConfiguration()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
    /// - Tag: PlaceARContent
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let imageAnchor = anchor as? ARImageAnchor else { return }
        
        // Image Anchor Processing
        let referenceImage = imageAnchor.referenceImage
        let imageName = referenceImage.name ?? "no name"

        let plane = SCNPlane(width: referenceImage.physicalSize.width, height: referenceImage.physicalSize.height)

        // Set up the product card

        if (imageName == "Bose") {
             fileName = "boseCard"
        }

        else if (imageName == "Fallout") {
             fileName = "falloutCard"
        }

        else if (imageName == "iPhone") {
             fileName = "iPhoneCard"
        }

        let spriteKitScene = SKScene(fileNamed: fileName)

        let spriteRatio = (spriteKitScene?.size.width)! / (spriteKitScene?.size.height)!
        let cardPlane = SCNPlane(width: spriteRatio * referenceImage.physicalSize.height, height: referenceImage.physicalSize.height)

        cardPlane.firstMaterial?.diffuse.contents = spriteKitScene
        cardPlane.firstMaterial?.diffuse.contentsTransform = SCNMatrix4Translate(SCNMatrix4MakeScale(1, -1, 1), 0, 1, 0)

        let planeNode = SCNNode(geometry: cardPlane)
        planeNode.eulerAngles.x = -.pi / 2
        planeNode.position.x = planeNode.position.x + Float(referenceImage.physicalSize.width  ) + Float(referenceImage.physicalSize.width / 4)
        
        node.addChildNode(planeNode)
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
    func configureLighting()
    {
        sceneView.autoenablesDefaultLighting = true
        sceneView.automaticallyUpdatesLighting = true
    }
    
    func resetTrackingConfiguration() {
        guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) else { return }
        let configuration = ARWorldTrackingConfiguration()
        configuration.detectionImages = referenceImages
        let options: ARSession.RunOptions = [.resetTracking, .removeExistingAnchors]
        sceneView.session.run(configuration, options: options)
        sceneInfoLabel.text = "Move camera around to detect images"
    }
    
}
