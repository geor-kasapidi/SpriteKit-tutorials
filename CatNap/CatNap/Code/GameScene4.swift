import Foundation
import SpriteKit

final class GameScene4: BaseScene {
    override func restart() {
        let scene = SKScene(fileNamed: "GameScene4")
        scene?.scaleMode = scaleMode
        view?.presentScene(scene)
    }
}
