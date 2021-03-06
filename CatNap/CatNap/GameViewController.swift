import UIKit
import SpriteKit

class GameViewController: UIViewController {
    private lazy var skView = view as! SKView

    override func viewDidLoad() {
        super.viewDidLoad()

        let scene = SKScene(fileNamed: "GameScene2")
        scene?.scaleMode = .aspectFill
        skView.presentScene(scene)

        scene?.isPaused = true
        scene?.isPaused = false

        skView.ignoresSiblingOrder = false
        skView.showsPhysics = true
        skView.showsFPS = true
        skView.showsNodeCount = true
    }
}
