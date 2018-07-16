import UIKit
import SpriteKit

class GameViewController: UIViewController {
    private lazy var skView = view as! SKView

    override func viewDidLoad() {
        super.viewDidLoad()

        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true

        let width: CGFloat = 2048
        let height: CGFloat = width * UIScreen.main.bounds.height / UIScreen.main.bounds.width

        let scene = MainMenuScene(size: CGSize(width: width, height: height))
        scene.scaleMode = .aspectFill

        skView.presentScene(scene)
    }
}
