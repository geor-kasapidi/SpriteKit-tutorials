//
//  GameViewController.swift
//  ZombieKonga
//
//  Created by JessyKiss on 10.07.2018.
//  Copyright © 2018 N7. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    private lazy var skView = view as! SKView

    override func viewDidLoad() {
        super.viewDidLoad()

        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true

        let width: CGFloat = 2048
        let height: CGFloat = width * UIScreen.main.bounds.height / UIScreen.main.bounds.width

        let scene = GameScene(size: CGSize(width: width, height: height))
        scene.scaleMode = .aspectFill

        skView.presentScene(scene)
    }
}
