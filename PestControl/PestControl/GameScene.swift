import SpriteKit

class GameScene: SKScene {
    private lazy var backgroundNode = childNode(withName: "background") as! SKTileMapNode
    
    private let player = PlayerNode()

    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        addChild(player)
        
        backgroundNode.physicsBody = SKPhysicsBody(edgeLoopFrom: backgroundNode.frame)
        
        camera?.constraints = [SKConstraint.distance(SKRange(constantValue: 0), to: player)]
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        guard let point = touches.first?.location(in: self) else {
            return
        }
        
        player.move(to: point)
    }
}
