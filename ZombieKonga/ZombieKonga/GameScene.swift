import SpriteKit
import GameplayKit

final class GameScene: SKScene {
    private let backgroundNode = SKSpriteNode(imageNamed: "background1")
    private let zombieNode = SKSpriteNode(imageNamed: "zombie1")
    private let enemyNode = SKSpriteNode(imageNamed: "enemy")

    private let sceneBounds: CGRect
    private let gameArea: CGRect
    private let enemyMovePointsPerSec: CGFloat = 200
    private let zombieMovePointsPerSec: CGFloat = 480

    private lazy var hitCatSoundAction = SKAction.playSoundFileNamed("hitCat.wav", waitForCompletion: false)

    override init(size: CGSize) {
        sceneBounds = CGRect(origin: .zero, size: size)
        gameArea = sceneBounds.insetBy(dx: 200, dy: 200)

        super.init(size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    override func didMove(to view: SKView) {
        backgroundColor = SKColor.black

        let center = CGPoint(x: size.width/2, y: size.height/2)

        // add background

        do {
            backgroundNode.zPosition = -1
            backgroundNode.position = center

            addChild(backgroundNode)
        }

        // add zombie

        do {
            zombieNode.zPosition = 1
            zombieNode.position = CGPoint(x: 400, y: 400)

            addChild(zombieNode)
        }

        // add enemy

        do {
            enemyNode.name = "enemy"
            enemyNode.zPosition = 2
            enemyNode.position = CGPoint(x: size.width - 400, y: size.height - 400)

            addChild(enemyNode)
        }

        // move enemy

        moveEnemy()

        // catocalypse

        do {
            let addCat = SKAction.run { [weak self] in
                self?.addCat()
            }

            run(SKAction.repeatForever(SKAction.sequence([addCat, SKAction.wait(forDuration: 1)])))
        }
    }

    // MARK: -

    override func didEvaluateActions() {
        checkCollisions()
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touches.first.flatMap { didTouch($0.location(in: self)) }
    }

    // MARK: -

    private func didTouch(_ touchLocation: CGPoint) {
        moveZombie(to: touchLocation)
    }

    private func checkCollisions() {
        enumerateChildNodes(withName: "cat") { [hitCatSoundAction, zombieNode] (catNode, _) in
            if catNode.frame.intersects(zombieNode.frame) {
                catNode.run(SKAction.sequence([hitCatSoundAction, SKAction.removeFromParent()]))
            }
        }

        if enemyNode.frame.insetBy(dx: 20, dy: 20).intersects(zombieNode.frame) {
            addBlinkActionToZombie()
        }
    }

    private func randomPointInGameArea() -> CGPoint {
        return CGPoint(
            x: CGFloat.random(min: gameArea.minX, max: gameArea.maxX),
            y: CGFloat.random(min: gameArea.minY, max: gameArea.maxY)
        )
    }

    private func addCat() {
        let cat = SKSpriteNode(imageNamed: "cat")
        cat.name = "cat"
        cat.position = randomPointInGameArea()
        cat.setScale(0)
        cat.zRotation = -π/16

        addChild(cat)

        do {
            let appear = SKAction.scale(to: 1, duration: 0.5)
            let wiggleAndScale: SKAction
            do {
                let leftWiggle = SKAction.rotate(byAngle: π/8, duration: 0.5)
                let rightWiggle = leftWiggle.reversed()
                let fullWiggle = SKAction.sequence([leftWiggle, rightWiggle])

                let scaleUp = SKAction.scale(by: 1.2, duration: 0.25)
                let scaleDown = scaleUp.reversed()
                let fullScale = SKAction.sequence([scaleUp, scaleDown, scaleUp, scaleDown])

                wiggleAndScale = SKAction.repeat(SKAction.group([fullScale, fullWiggle]), count: 10)
            }
            let disappear = SKAction.scale(to: 0, duration: 0.5)
            let remove = SKAction.removeFromParent()
            let actions = [appear, wiggleAndScale, disappear, remove]

            cat.run(SKAction.sequence(actions))
        }
    }

    private func moveEnemy() {
        let toPoint = randomPointInGameArea()

        let duration = TimeInterval((toPoint - enemyNode.position).length / enemyMovePointsPerSec)

        enemyNode.run(SKAction.move(to: toPoint, duration: duration)) { [weak self] in
            self?.moveEnemy()
        }
    }

    private func addBlinkActionToZombie() {
        guard zombieNode.action(forKey: "blink") == nil else {
            return
        }
        
        let blinkAction = SKAction.repeat(SKAction.sequence([SKAction.hide(),
                                                             SKAction.wait(forDuration: 0.2),
                                                             SKAction.unhide(),
                                                             SKAction.wait(forDuration: 0.2)]), count: 5)
        
        zombieNode.run(blinkAction, withKey: "blink")
    }

    private func addAnimationToZombie() {
        guard zombieNode.action(forKey: "animation") == nil else {
            return
        }

        let textures = [1,2,3,4,3,2].map { SKTexture(imageNamed: "zombie\($0)") }

        zombieNode.run(SKAction.repeatForever(SKAction.animate(with: textures, timePerFrame: 0.1)), withKey: "animation")
    }

    private func removeAnimationFromZombie() {
        zombieNode.removeAction(forKey: "animation")
    }

    private func moveZombie(to toPoint: CGPoint) {
        let duration = TimeInterval((toPoint - zombieNode.position).length / zombieMovePointsPerSec)

        let velocity = (toPoint - zombieNode.position).normalize() * zombieMovePointsPerSec

        let rotation = GeometryUtils.shortestAngle(between: zombieNode.zRotation, and: velocity.angle)

        zombieNode.removeAction(forKey: "move")
        zombieNode.removeAction(forKey: "rotate")

        zombieNode.run(SKAction.move(to: toPoint, duration: duration), withKey: "move")
        zombieNode.run(SKAction.rotate(byAngle: rotation, duration: 0.2), withKey: "rotate")
    }
}
