import Foundation
import SpriteKit

final class GameScene4: BaseScene {
    override func restart() {
        let scene = SKScene(fileNamed: "GameScene4")
        scene?.scaleMode = scaleMode
        view?.presentScene(scene)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        guard let point = touches.first?.location(in: self) else {
            return
        }
        
        showArrow(at: point)
    }
}
