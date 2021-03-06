import Foundation
import SpriteKit

final class CatNode: SKSpriteNode, CustomNode {
    func didMoveToScene() {
        let texture = SKTexture(imageNamed: "cat_body_outline")
        physicsBody = SKPhysicsBody(texture: texture, size: texture.size())
        physicsBody?.categoryBitMask = PhysicsCategory.cat
        physicsBody?.collisionBitMask = PhysicsCategory.block | PhysicsCategory.edge | PhysicsCategory.spring
        physicsBody?.contactTestBitMask = PhysicsCategory.edge | PhysicsCategory.bed
        
        isAwake = false
    }
    
    var isAwake: Bool = false {
        didSet {
            children.forEach { node in
                if node.name == "cat_awake" {
                    node.isHidden = !isAwake
                } else {
                    node.isHidden = isAwake
                }
            }
        }
    }
    
    var onTap: (() -> Void)? {
        didSet {
            isUserInteractionEnabled = true
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        onTap?()
    }
}
