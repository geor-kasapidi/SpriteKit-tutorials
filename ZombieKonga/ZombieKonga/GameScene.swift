import SpriteKit
import GameplayKit

class GameScene: SKScene {
    let backgroundNode = SKSpriteNode(imageNamed: "background1")
    let zombieNode = SKSpriteNode(imageNamed: "zombie1")

    override func didMove(to view: SKView) {
        backgroundColor = SKColor.black

        // add background

        do {
            backgroundNode.zPosition = -1
            backgroundNode.position = CGPoint(x: size.width/2, y: size.height/2)

            addChild(backgroundNode)
        }

        // add zombie

        do {
            zombieNode.zPosition = 1
            zombieNode.position = CGPoint(x: 400, y: 400)

            addChild(zombieNode)
        }
    }

    // MARK: -

    private var lastUpdateTime: TimeInterval = 0
    private var dt: TimeInterval = 0

    private let zombieMovePointsPerSec: CGFloat = 480
    private var zombieVelocity: CGPoint = .zero
    private var lastTouchLocation: CGPoint = .zero

    private var angleOld: CGFloat = 0
    private var angleNew: CGFloat = 0

    // MARK: -

    override func update(_ currentTime: TimeInterval) {
        dt = lastUpdateTime > 0 ? currentTime - lastUpdateTime : 0
        lastUpdateTime = currentTime

        checkZombieBounds()

        zombieNode.position = zombieNode.position + zombieVelocity * CGFloat(dt)
        zombieNode.zRotation = zombieVelocity.angle

        if (zombieNode.position - lastTouchLocation).length <= CGFloat(zombieMovePointsPerSec * CGFloat(dt)) {
            zombieVelocity = .zero
        }
    }

    // MARK: -

    private func didTouch(_ touchLocation: CGPoint) {
        lastTouchLocation = touchLocation
        angleOld = zombieVelocity.angle
        zombieVelocity = (touchLocation - zombieNode.position).normalize() * zombieMovePointsPerSec
        angleNew = zombieVelocity.angle
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touches.first.flatMap { didTouch($0.location(in: self)) }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        touches.first.flatMap { didTouch($0.location(in: self)) }
    }

    // MARK: -

    private func checkZombieBounds() {
        if zombieNode.position.x < 0 {
            zombieNode.position.x = 0
            zombieVelocity.x = -zombieVelocity.x
        }

        if zombieNode.position.y < 0 {
            zombieNode.position.y = 0
            zombieVelocity.y = -zombieVelocity.y
        }

        if zombieNode.position.x > size.width {
            zombieNode.position.x = size.width
            zombieVelocity.x = -zombieVelocity.x
        }

        if zombieNode.position.y > size.height {
            zombieNode.position.y = size.height
            zombieVelocity.y = -zombieVelocity.y
        }
    }
}
