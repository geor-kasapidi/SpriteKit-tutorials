import Foundation
import SpriteKit

final class GameScene3: BaseScene {
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        do {
            let compoundNode = BlockNode()
            
            var bodies: [SKPhysicsBody] = []
            
            enumerateChildNodes(withName: "stone") { (node, _) in
                node.move(toParent: compoundNode)
                
                bodies.append(SKPhysicsBody(rectangleOf: (node as! SKSpriteNode).size, center: node.position))
            }
            
            compoundNode.physicsBody = SKPhysicsBody(bodies: bodies)

            addChild(compoundNode)
            
            compoundNode.didMoveToScene()
        }
    }
    
    override func restart() {
        let scene = GameScene3(fileNamed: "GameScene3")
        scene?.scaleMode = scaleMode
        view?.presentScene(scene)
    }
}
