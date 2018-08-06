import Foundation
import SpriteKit

final class SeesawNode: SKSpriteNode, CustomNode {
    func didMoveToScene() {
        physicsBody!.collisionBitMask = PhysicsCategory.block | PhysicsCategory.cat
        physicsBody!.categoryBitMask = PhysicsCategory.block
        
        isUserInteractionEnabled = true
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        guard let point = touches.first?.location(in: scene ?? self) else {
            return
        }
        
        onTap(point)
    }
    
    private func onTap(_ point: CGPoint) {
        physicsBody?.applyImpulse(CGVector(dx: 0, dy: 2000), at: point)
    }
}
