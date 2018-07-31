import Foundation
import SpriteKit

final class CatNode: SKSpriteNode, CustomNode {
    func didMoveToScene() {
        let texture = SKTexture(imageNamed: "cat_body_outline")
        physicsBody = SKPhysicsBody(texture: texture, size: texture.size())
        physicsBody?.categoryBitMask = PhysicsCategory.cat
        physicsBody?.collisionBitMask = PhysicsCategory.block | PhysicsCategory.edge
        physicsBody?.contactTestBitMask = PhysicsCategory.edge | PhysicsCategory.bed
    }
}
