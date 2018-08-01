import Foundation
import SpriteKit

final class SpringNode: SKSpriteNode, CustomNode {
    func didMoveToScene() {
        physicsBody?.categoryBitMask = PhysicsCategory.spring
        physicsBody?.collisionBitMask = PhysicsCategory.cat | PhysicsCategory.block | PhysicsCategory.edge
        isUserInteractionEnabled = true
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        onTap()
    }
    
    private func onTap() {
        isUserInteractionEnabled = false
        
        physicsBody?.applyImpulse(CGVector(dx: 0, dy: 250), at: CGPoint(x: size.width/2, y: size.height))
        
        run(SKAction.sequence([
            SKAction.wait(forDuration: 1),
            SKAction.removeFromParent()
            ]))
    }
}
