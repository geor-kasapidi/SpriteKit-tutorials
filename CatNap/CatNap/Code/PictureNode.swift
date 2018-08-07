import Foundation
import SpriteKit

final class PictureNode: SKSpriteNode, CustomNode {
    func didMoveToScene() {
        do {
            let zombie = SKSpriteNode(imageNamed: "picture")
            let mask = SKSpriteNode(imageNamed: "picture-frame-mask")
            
            let cropNode = SKCropNode()
            cropNode.addChild(zombie)
            cropNode.maskNode = mask
            
            addChild(cropNode)
        }
        
        physicsBody!.collisionBitMask = PhysicsCategory.block | PhysicsCategory.cat | PhysicsCategory.edge
        physicsBody!.categoryBitMask = PhysicsCategory.block
        
        isUserInteractionEnabled = true
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        physicsBody?.isDynamic = true
    }
}
