import Foundation
import SpriteKit

final class YouLoseScene: SKScene {
    private let backgroundNode = SKSpriteNode(imageNamed: "YouLose")

    override func didMove(to view: SKView) {
        backgroundColor = SKColor.black

        let center = CGPoint(x: size.width/2, y: size.height/2)

        // add background

        do {
            backgroundNode.zPosition = -1
            backgroundNode.position = center

            addChild(backgroundNode)

            backgroundNode.run(SKAction.sequence([SKAction.wait(forDuration: 3), SKAction.run({ [weak self] in
                self?.showMainMenu()
            })]))
        }
    }

    private func showMainMenu() {
        let scene = MainMenuScene(size: size)
        scene.scaleMode = scaleMode

        view?.presentScene(scene, transition: SKTransition.doorsCloseHorizontal(withDuration: 0.5))
    }
}
