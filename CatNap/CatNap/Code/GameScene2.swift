import Foundation
import SpriteKit

final class GameScene2: BaseScene {
    private lazy var hookBaseNode = childNode(withName: "hook_base") as! SKSpriteNode
    private lazy var ropeNode = childNode(withName: "rope") as! SKSpriteNode
    private lazy var hookNode = childNode(withName: "hook") as! SKSpriteNode
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        catNode.constraints = [
            SKConstraint.zRotation(SKRange(lowerLimit: 0, upperLimit: 0))
        ]

        do {
//            hookNode.physicsBody?.density = 2
            
            hookNode.physicsBody?.categoryBitMask = PhysicsCategory.hook
            hookNode.physicsBody?.collisionBitMask = PhysicsCategory.none
            hookNode.physicsBody?.contactTestBitMask = PhysicsCategory.none
        }
        
        physicsWorld.add(SKPhysicsJointPin.joint(
            withBodyA: ropeNode.physicsBody!,
            bodyB: hookBaseNode.physicsBody!,
            anchor: hookBaseNode.position
        ))
        
        physicsWorld.add(SKPhysicsJointFixed.joint(
            withBodyA: hookNode.physicsBody!,
            bodyB: ropeNode.physicsBody!,
            anchor: CGPoint(x: ropeNode.position.x, y: ropeNode.position.y - ropeNode.size.height/2)
        ))

        hookNode.physicsBody?.applyImpulse(CGVector(dx: 300, dy: 0))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.hookNode.physicsBody?.contactTestBitMask = PhysicsCategory.cat
        }
        
        catNode.onTap = { [weak self] in
            self?.releaseCat()
        }
    }
    
    override func didBegin(_ contact: SKPhysicsContact) {
        super.didBegin(contact)
        
        let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask

        if collision == PhysicsCategory.cat | PhysicsCategory.hook {
            hookCat(at: contact.contactPoint)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        catNode.physicsBody?.applyImpulse(CGVector(dx: 1000, dy: 0))
    }
    
    private weak var hookCatJoint: SKPhysicsJoint?

    private func hookCat(at point: CGPoint) {
        guard hookCatJoint == nil else { return }
        
        let joint = SKPhysicsJointFixed.joint(
            withBodyA: catNode.physicsBody!,
            bodyB: hookNode.physicsBody!,
            anchor: point
        )

        physicsWorld.add(joint)
        
        hookCatJoint = joint
        
        hookNode.physicsBody?.contactTestBitMask = PhysicsCategory.none
    }
    
    private func releaseCat() {
        guard let joint = hookCatJoint else { return }
        
        physicsWorld.remove(joint)

        hookNode.physicsBody?.contactTestBitMask = PhysicsCategory.cat
    }
    
    override func restart() {
        let scene = GameScene2(fileNamed: "GameScene2")
        scene?.scaleMode = scaleMode
        view?.presentScene(scene)
    }
}
