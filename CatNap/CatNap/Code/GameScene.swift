import Foundation
import SpriteKit

final class GameScene: SKScene, SKPhysicsContactDelegate {
    private lazy var bedNode = childNode(withName: "//bed") as! BedNode
    private lazy var catNode = childNode(withName: "//cat") as! CatNode
    
    override func didMove(to view: SKView) {
        do {
            let screenSize = UIScreen.main.bounds.size
            let inset = (size.height - size.width / screenSize.width * screenSize.height) / 2
            let edges = CGRect(x: 0, y: inset, width: size.width, height: size.height - inset * 2)
            
            physicsBody = SKPhysicsBody(edgeLoopFrom: edges)
            physicsBody?.categoryBitMask = PhysicsCategory.edge
        }
        
        do {
            enumerateChildNodes(withName: "block") { (node, _) in
                node.physicsBody?.categoryBitMask = PhysicsCategory.block
                node.physicsBody?.collisionBitMask = PhysicsCategory.cat | PhysicsCategory.block | PhysicsCategory.edge
                node.isUserInteractionEnabled = true
            }
        }
        
        enumerateChildNodes(withName: "//*") { (node, _) in
            (node as? CustomNode)?.didMoveToScene()
        }
        
        physicsWorld.contactDelegate = self
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if collision == PhysicsCategory.cat | PhysicsCategory.bed {
            print("WIN")
        } else if collision == PhysicsCategory.cat | PhysicsCategory.edge {
            print("FAIL")
        }
    }
}
