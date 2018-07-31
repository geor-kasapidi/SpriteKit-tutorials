import Foundation
import SpriteKit

final class BlockNode: SKSpriteNode {
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        guard name == "block" else {
            return
        }
        
        onTap()
    }
    
    private func onTap() {
        name = "tapped_block"
        
        run(SKAction.sequence([
            SKAction.scale(to: 0.8, duration: 0.1),
            SKAction.removeFromParent()
            ]))
    }
}
