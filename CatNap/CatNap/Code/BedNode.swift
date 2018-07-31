import Foundation
import SpriteKit

final class BedNode: SKSpriteNode, CustomNode {
    func didMoveToScene() {
        physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 40, height: 30))
        physicsBody?.categoryBitMask = PhysicsCategory.bed
        physicsBody?.collisionBitMask = PhysicsCategory.none
        physicsBody?.isDynamic = false
    }
}
