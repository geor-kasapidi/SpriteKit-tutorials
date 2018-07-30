import SpriteKit
import PlaygroundSupport

let size = CGSize(width: 480, height: 320)

let scene = SKScene(size: size)
do {
    scene.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
        scene.physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
    }
}
scene.physicsBody = SKPhysicsBody(edgeLoopFrom: scene.frame)

let sceneView = SKView(frame: CGRect(origin: .zero, size: size))
sceneView.showsPhysics = true
sceneView.showsFPS = true
sceneView.presentScene(scene)

// square

do {
    let shape = SKSpriteNode(imageNamed: "square")
    shape.name = "shape"
    shape.position = CGPoint(x: size.width * 0.25, y: size.height * 0.5)
    shape.physicsBody = SKPhysicsBody(rectangleOf: shape.size)
    scene.addChild(shape)
}

// circle

do {
    let shape = SKSpriteNode(imageNamed: "circle")
    shape.name = "shape"
    shape.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
    shape.physicsBody = SKPhysicsBody(circleOfRadius: shape.size.width/2)
    scene.addChild(shape)
}

// triangle

do {
    let shape = SKSpriteNode(imageNamed: "triangle")
    shape.name = "shape"
    shape.position = CGPoint(x: size.width * 0.75, y: size.height * 0.5)
    do {
        let path = CGMutablePath()
        path.move(to: CGPoint(x: -shape.size.width/2, y: -shape.size.height/2))
        path.addLine(to: CGPoint(x: shape.size.width/2, y: -shape.size.height/2))
        path.addLine(to: CGPoint(x: 0, y: shape.size.height/2))
        path.addLine(to: CGPoint(x: -shape.size.width/2, y: -shape.size.height/2))
        shape.physicsBody = SKPhysicsBody(polygonFrom: path)
    }
    scene.addChild(shape)
}

// L

do {
    let shape = SKSpriteNode(imageNamed: "L")
    shape.name = "shape"
    shape.position = CGPoint(x: size.width * 0.5, y: size.height * 0.75)
    shape.physicsBody = SKPhysicsBody(texture: shape.texture!, size: shape.size)
    scene.addChild(shape)
}

// sand

do {
    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
        scene.run(SKAction.repeat(SKAction.sequence([
            SKAction.run({
                let node = SKSpriteNode(imageNamed: "sand")
                node.name = "sand"
                node.position = CGPoint(x: CGFloat(drand48()) * size.width, y: size.height - node.size.height)
                node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width/2)
//                node.physicsBody?.density = 20
                scene.addChild(node)
            }),
            SKAction.wait(forDuration: 0.1)
            ]), count: 100))
    }
}

DispatchQueue.main.asyncAfter(deadline: .now() + 20) {
    scene.enumerateChildNodes(withName: "sand", using: { (node, _) in
        node.physicsBody?.applyForce(CGVector(dx: 50, dy: 0))
//        node.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 20 + CGFloat(drand48()) * 40))
    })
}

PlaygroundPage.current.needsIndefiniteExecution = true
PlaygroundPage.current.liveView = sceneView
