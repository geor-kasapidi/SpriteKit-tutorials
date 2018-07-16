import SpriteKit
import GameplayKit

final class GameScene: SKScene {
    private let backgroundNode = SKSpriteNode(imageNamed: "background1")
    private let zombieNode = SKSpriteNode(imageNamed: "zombie1")
    private let enemyNode = SKSpriteNode(imageNamed: "enemy")

    private let sceneBounds: CGRect
    private let gameArea: CGRect
    private let enemySpeed: CGFloat = 640 // points per sec
    private let zombieSpeed: CGFloat = 480 // points per sec

    private var zombieCatNodes: [SKNode] = []

    private var zombieLives: Int = 3

    private var lastUpdateTime: TimeInterval = 0
    private var dt: TimeInterval = 0

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

            run(SKAction.repeatForever(SKAction.sequence([addCat, SKAction.wait(forDuration: 3)])))
        }
    }

    // MARK: -

    override func update(_ currentTime: TimeInterval) {
        dt = lastUpdateTime > 0 ? currentTime - lastUpdateTime : 0
        lastUpdateTime = currentTime
    }

    override func didEvaluateActions() {
        checkCollisions()

        updateTrainPosition()

        guard zombieLives == 0 else {
            return
        }

        showYouLoseScene()
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touches.first.flatMap { didTouch($0.location(in: self)) }
    }

    // MARK: -

    private func didTouch(_ touchPoint: CGPoint) {
        moveZombie(to: touchPoint)
    }

    private func checkCollisions() {
        enumerateChildNodes(withName: "cat") { (catNode, _) in
            if catNode.frame.intersects(self.zombieNode.frame) {
                if !self.makeCatZombie(catNode) {
                    self.removeCat(node: catNode)
                }
            }
        }

        if enemyNode.frame.insetBy(dx: 20, dy: 20).intersects(zombieNode.frame) {
            if addBlinkActionToZombie() {
                if !removeLastZombieCat() {
                    zombieLives -= 1
                }
            }
        }
    }

    private func updateTrainPosition() {
        var frontNode: SKNode = zombieNode

        for node in zombieCatNodes {
            let distance = frontNode.position - node.position

            let distanceWithOffset = frontNode.position - distance.normalize() * 200 - node.position

            if distanceWithOffset.length > 5 {
                let amountToMove = distanceWithOffset.normalize() * self.zombieSpeed * CGFloat(self.dt)

                node.position = node.position + amountToMove
            }

            node.zRotation = distance.angle

            frontNode = node
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

        let duration = TimeInterval((toPoint - enemyNode.position).length / enemySpeed)

        enemyNode.run(SKAction.move(to: toPoint, duration: duration)) { [weak self] in
            self?.moveEnemy()
        }
    }

    private func addBlinkActionToZombie() -> Bool {
        guard zombieNode.action(forKey: "blink") == nil else {
            return false
        }
        
        let blinkAction = SKAction.repeat(SKAction.sequence([SKAction.hide(),
                                                             SKAction.wait(forDuration: 0.2),
                                                             SKAction.unhide(),
                                                             SKAction.wait(forDuration: 0.2)]), count: 5)
        
        zombieNode.run(blinkAction, withKey: "blink")

        return true
    }

    private func moveZombie(to toPoint: CGPoint) {
        let distance = toPoint - zombieNode.position
        
        let duration = TimeInterval(distance.length / zombieSpeed)
        
        let rotation = GeometryUtils.shortestAngle(between: zombieNode.zRotation, and: distance.angle)
        
        zombieNode.removeAction(forKey: "move")
        
        let animateAction: SKAction
        
        do {
            let textures = [1,2,3,4,3,2].map { SKTexture(imageNamed: "zombie\($0)") }
            let timePerFrame: TimeInterval = 0.1
            let repeatCount = Int((duration / (TimeInterval(textures.count) * timePerFrame)).rounded(.up))
            
            animateAction = SKAction.repeat(SKAction.animate(with: textures, timePerFrame: timePerFrame), count: repeatCount)
        }
        
        zombieNode.run(SKAction.group([animateAction,
                                       SKAction.move(to: toPoint, duration: duration),
                                       SKAction.rotate(byAngle: rotation, duration: 0.2)]), withKey: "move")
    }

    private func makeCatZombie(_ catNode: SKNode) -> Bool {
        guard zombieCatNodes.count < 5 else {
            return false
        }

        catNode.name = "zombie_cat"

        catNode.removeAllActions()

        catNode.run(SKAction.group([hitCatSoundAction,
                                    SKAction.colorize(with: #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1), colorBlendFactor: 0.5, duration: 0.2),
                                    SKAction.scale(to: 1, duration: 0.2)]))

        zombieCatNodes.append(catNode)

        return true
    }

    private func removeCat(node: SKNode) {
        node.name = "dead_cat"

        node.removeAllActions()

        node.run(SKAction.sequence([SKAction.scale(to: 0, duration: 0.5),
                                    SKAction.removeFromParent()]))
    }

    private func removeLastZombieCat() -> Bool {
        guard !zombieCatNodes.isEmpty else {
            return false
        }

        let node = zombieCatNodes.removeLast()

        node.run(SKAction.sequence([SKAction.scale(to: 0, duration: 0.5),
                                    SKAction.removeFromParent()]))

        return true
    }

    private func showYouLoseScene() {
        let scene = YouLoseScene(size: size)
        scene.scaleMode = scaleMode

        view?.presentScene(scene, transition: SKTransition.flipHorizontal(withDuration: 0.5))
    }
}
