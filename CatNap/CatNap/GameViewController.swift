import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    private lazy var skView = view as! SKView

    override func viewDidLoad() {
        super.viewDidLoad()

        skView.ignoresSiblingOrder = false
        skView.showsFPS = true
        skView.showsNodeCount = true

        let scene = SKScene(fileNamed: "GameScene")!
        scene.scaleMode = .aspectFill
        skView.presentScene(scene)
    }
}
