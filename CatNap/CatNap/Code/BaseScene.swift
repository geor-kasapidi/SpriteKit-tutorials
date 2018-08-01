import Foundation
import SpriteKit

class BaseScene: SKScene, SKPhysicsContactDelegate {
    override func didMove(to view: SKView) {
        do {
            let screenSize = UIScreen.main.bounds.size
            let inset = (size.height - size.width / screenSize.width * screenSize.height) / 2
            let edges = CGRect(x: 0, y: inset, width: size.width, height: size.height - inset * 2)
            
            physicsBody = SKPhysicsBody(edgeLoopFrom: edges)
            physicsBody?.categoryBitMask = PhysicsCategory.edge
        }
        
        enumerateChildNodes(withName: "//*") { (node, _) in
            (node as? CustomNode)?.didMoveToScene()
        }
        
        physicsWorld.contactDelegate = self
    }
}
