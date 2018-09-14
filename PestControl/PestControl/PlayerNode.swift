import Foundation
import SpriteKit

final class PlayerNode: SKSpriteNode {
    init() {
        let texture = SKTexture(imageNamed: "player_ft1")
        super.init(texture: texture, color: UIColor.white, size: texture.size()) 
        name = "player"
        zPosition = 50
        
        do {
            let body = SKPhysicsBody(circleOfRadius: size.width/2)
            body.restitution = 1
            body.linearDamping = 0.5
            body.friction = 0
            body.allowsRotation = false
            
            physicsBody = body
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    func move(to point: CGPoint) {
        let v = (point - position).normalized() * 280
        
        physicsBody?.velocity = CGVector(dx: v.x, dy: v.y)
    }
}
