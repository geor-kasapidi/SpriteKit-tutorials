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
    
    final func showArrow(at point: CGPoint) {
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: -68.5, y: 1.5))
        bezierPath.addLine(to: CGPoint(x: -24.5, y: -35.5))
        bezierPath.addLine(to: CGPoint(x: -24.5, y: -13.5))
        bezierPath.addLine(to: CGPoint(x: 63.5, y: -13.5))
        bezierPath.addLine(to: CGPoint(x: 63.5, y: 1.5))
        bezierPath.addLine(to: CGPoint(x: 63.5, y: 16.5))
        bezierPath.addLine(to: CGPoint(x: -24.5, y: 16.5))
        bezierPath.addLine(to: CGPoint(x: -24.5, y: 36.5))
        bezierPath.addLine(to: CGPoint(x: -68.5, y: 1.5))
        UIColor.green.setFill()
        bezierPath.fill()
        UIColor.black.setStroke()
        bezierPath.lineWidth = 1
        bezierPath.stroke()
        
        let node = SKShapeNode(path: bezierPath.cgPath)
        node.glowWidth = 5
        node.fillColor = SKColor.green
        node.fillTexture = SKTexture(imageNamed: "wood_tinted")
        node.alpha = 0.8
        node.position = point
        
        addChild(node)
        
        let move = SKAction.moveBy(x: -40, y: 0, duration: 1)

        node.run(SKAction.sequence([SKAction.repeat(SKAction.sequence([move, move.reversed()]), count: 3), SKAction.removeFromParent()]))
    }
    
    func restart() {}
}
