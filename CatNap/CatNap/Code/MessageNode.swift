import Foundation
import SpriteKit

final class MessageNode: SKLabelNode {
    convenience init(message: String) {
        self.init(fontNamed: "AvenirNext-Regular")
        text = message
        fontSize = 256.0
        fontColor = SKColor.gray
        zPosition = 100
        let front = SKLabelNode(fontNamed: "AvenirNext-Regular")
        front.text = message
        front.fontSize = 256.0
        front.fontColor = SKColor.white
        front.position = CGPoint(x: -2, y: -2)
        addChild(front)
        
        do {
            physicsBody = SKPhysicsBody(circleOfRadius: 10)
            physicsBody?.collisionBitMask = PhysicsCategory.edge
            physicsBody?.categoryBitMask = PhysicsCategory.label
            physicsBody?.contactTestBitMask = PhysicsCategory.edge
            physicsBody?.restitution = 0.7
        }
    }
}
