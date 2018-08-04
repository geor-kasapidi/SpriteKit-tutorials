import Foundation
import SpriteKit

class BaseScene: SKScene, SKPhysicsContactDelegate {
    private(set) lazy var bedNode = childNode(withName: "//bed") as! BedNode
    private(set) lazy var catNode = childNode(withName: "//cat") as! CatNode
    
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
    
    func didBegin(_ contact: SKPhysicsContact) {
        let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        // label collisitions
        
        if collision == PhysicsCategory.label | PhysicsCategory.edge {
            messageBounceCount += 1
            
            if messageBounceCount == 4 {
                currentMessageNode?.removeFromParent()
            }
        }
        
        guard isPlayable else { return }
        
        if collision == PhysicsCategory.cat | PhysicsCategory.bed {
            win()
        } else if collision == PhysicsCategory.cat | PhysicsCategory.edge {
            lose()
        }
    }
    
    private(set) var isPlayable: Bool = true
    
    final func win() {
        isPlayable = false
        
        catNode.removeFromParent()
        
        do {
            let curlNode = SKSpriteNode(fileNamed: "CatCurl")!.childNode(withName: "cat_curl")!
            curlNode.position =  CGPoint(x: bedNode.position.x, y: bedNode.position.y + 100)
            curlNode.move(toParent: self)
            curlNode.isPaused = false
        }
        
        show(message: "Nice job!")
        
        run(SKAction.sequence([
            SKAction.wait(forDuration: 5),
            SKAction.run { [weak self] in
                self?.restart()
            }
            ]))
    }
    
    final func lose() {
        isPlayable = false
        
        catNode.isAwake = true
        
        show(message: "Try again...")
        
        run(SKAction.sequence([
            SKAction.wait(forDuration: 5),
            SKAction.run { [weak self] in
                self?.restart()
            }
            ]))
    }
    
    private var messageBounceCount: Int = 0
    private weak var currentMessageNode: MessageNode?
    
    final func show(message: String) {
        messageBounceCount = 0
        
        let msg = MessageNode(message: message)
        msg.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(msg)
        currentMessageNode = msg
    }
    
    func restart() {}
}