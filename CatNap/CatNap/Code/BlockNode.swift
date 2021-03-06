import Foundation
import SpriteKit

final class BlockNode: SKSpriteNode, CustomNode {
    func didMoveToScene() {
        physicsBody?.categoryBitMask = PhysicsCategory.block
        physicsBody?.collisionBitMask = PhysicsCategory.cat | PhysicsCategory.block | PhysicsCategory.spring | PhysicsCategory.edge
        isUserInteractionEnabled = true
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)

        onTap()
    }
    
    private func onTap() {
        isUserInteractionEnabled = false
        
        run(SKAction.sequence([
            SKAction.scale(to: 0.8, duration: 0.1),
            SKAction.removeFromParent()
            ]))
    }
}
