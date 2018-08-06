import Foundation
import SpriteKit

final class GameScene4: BaseScene {
    override func restart() {
        let scene = GameScene4(fileNamed: "GameScene4")
        scene?.scaleMode = scaleMode
        view?.presentScene(scene)
    }
}
