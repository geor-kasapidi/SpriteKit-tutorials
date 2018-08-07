import Foundation
import SpriteKit

final class GameScene: BaseScene {
    override func didSimulatePhysics() {
        guard isPlayable else { return }
        
        if abs(catNode.zRotation * 180) > 25 {
            lose()
        }
    }
    
    override func restart() {
        let scene = SKScene(fileNamed: "GameScene")
        scene?.scaleMode = scaleMode
        view?.presentScene(scene)
    }
}
