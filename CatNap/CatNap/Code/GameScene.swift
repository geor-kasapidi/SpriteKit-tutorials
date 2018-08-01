import Foundation
import SpriteKit

final class GameScene: BaseScene {
    private lazy var bedNode = childNode(withName: "//bed") as! BedNode
    private lazy var catNode = childNode(withName: "//cat") as! CatNode

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
    
    override func didSimulatePhysics() {
        guard isPlayable else { return }
        
        if abs(catNode.zRotation * 180) > 25 {
            lose()
        }
    }
    
    private var isPlayable: Bool = true
   
    private func win() {
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
    
    private func lose() {
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
    
    private func show(message: String) {
        messageBounceCount = 0
        
        let msg = MessageNode(message: message)
        msg.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(msg)
        currentMessageNode = msg
    }
    
    private func restart() {
        let scene = GameScene(fileNamed: "GameScene")
        scene?.scaleMode = scaleMode
        view?.presentScene(scene)
    }
}
