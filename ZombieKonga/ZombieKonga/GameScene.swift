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
    private let zombieRotationRadiansPerSec: CGFloat = 4 * π

    private var lastUpdateTime: TimeInterval = 0
    private var dt: TimeInterval = 0
    private var zombieVelocity: CGPoint = .zero
    private var lastTouchLocation: CGPoint = .zero

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

    override func update(_ currentTime: TimeInterval) {
        dt = lastUpdateTime > 0 ? currentTime - lastUpdateTime : 0
        lastUpdateTime = currentTime

        check(position: &zombieNode.position, velocity: &zombieVelocity, in: gameArea)

        zombieNode.position = zombieNode.position + zombieVelocity * CGFloat(dt)

        rotate(sprite: zombieNode, rotationRadiansPerSec: zombieRotationRadiansPerSec)

        let distanceToTouchLocation = (lastTouchLocation - zombieNode.position).length

        if distanceToTouchLocation < 5 {
            zombieVelocity = .zero
            lastTouchLocation = .zero

            removeAnimationFromZombie()
        }
    }

    override func didEvaluateActions() {
        checkCollisions()
    }

    // MARK: -

    private func checkCollisions() {
        enumerateChildNodes(withName: "cat") { [zombieNode] (catNode, _) in
            if catNode.frame.intersects(zombieNode.frame) {
                let soundAction = SKAction.playSoundFileNamed("hitCat.wav", waitForCompletion: false)

                catNode.run(SKAction.sequence([soundAction, SKAction.removeFromParent()]))
            }
        }
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

    private func randomPointInGameArea() -> CGPoint {
        return CGPoint(
            x: CGFloat.random(min: gameArea.minX, max: gameArea.maxX),
            y: CGFloat.random(min: gameArea.minY, max: gameArea.maxY)
        )
    }

    // MARK: -

    private func didTouch(_ touchLocation: CGPoint) {
        lastTouchLocation = touchLocation
        zombieVelocity = (touchLocation - zombieNode.position).normalize() * zombieMovePointsPerSec

        addAnimationToZombie()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touches.first.flatMap { didTouch($0.location(in: self)) }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        touches.first.flatMap { didTouch($0.location(in: self)) }
    }

    // MARK: -

    private func rotate(sprite: SKSpriteNode, rotationRadiansPerSec: CGFloat) {
        let shortestAngle = GeometryUtils.shortestAngle(between: sprite.zRotation, and: zombieVelocity.angle)
        let amountToRotate = min(rotationRadiansPerSec * CGFloat(dt), abs(shortestAngle))
        sprite.zRotation += shortestAngle.sign() * amountToRotate
    }

    private func check(position: inout CGPoint, velocity: inout Vector, in bounds: CGRect) {
        if position.x < bounds.minX {
            position.x = bounds.minX
            velocity.x = -velocity.x
        }

        if position.y < bounds.minY {
            position.y = bounds.minY
            velocity.y = -velocity.y
        }

        if position.x > bounds.maxX {
            position.x = bounds.maxX
            velocity.x = -velocity.x
        }

        if position.y > bounds.maxY {
            position.y = bounds.maxY
            velocity.y = -velocity.y
        }
    }
}
