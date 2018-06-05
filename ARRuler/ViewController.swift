//
//  ViewController.swift
//  ARRuler
//
//  Created by Ruurd Pels on 05-06-2018.
//  Copyright © 2018 Bureau Pels. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    var dotNodes: [SCNNode] = []

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: sceneView)
            let results = sceneView.hitTest(location, types: .featurePoint)
            if let hit = results.first {
                addDot(at: hit)
            }
        }
    }

    func addDot(at hitResult: ARHitTestResult) {
        let dotGeom = SCNSphere(radius: 0.005)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.red
        dotGeom.materials = [material]
        let dotNode = SCNNode(geometry: dotGeom)

        dotNode.position = SCNVector3(x: hitResult.worldTransform.columns.3.x,
                                      y: hitResult.worldTransform.columns.3.y,
                                      z: hitResult.worldTransform.columns.3.z)
        sceneView.scene.rootNode.addChildNode(dotNode)
        dotNodes.append(dotNode)
        if dotNodes.count >= 2 {
            calculate()
        }
    }

    func calculate() {
        if let start = dotNodes.first {
            print(start.position)
            if let finish = dotNodes.last {
                print(finish.position)
                print(distance(from: start.position, to: finish.position))
            }
        }
    }

    func distance(from start: SCNVector3, to finish: SCNVector3) -> Float {
        let a = pow((start.x - finish.x), 2)
        let b = pow((start.y - finish.y), 2)
        let c = pow((start.z - finish.z), 2)
        return sqrt(a + b + c)
    }
}
