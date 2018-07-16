import Foundation
import SpriteKit

final class MainMenuScene: SKScene {
    private let backgroundNode = SKSpriteNode(imageNamed: "MainMenu")

    override func didMove(to view: SKView) {
        backgroundColor = SKColor.black

        let center = CGPoint(x: size.width/2, y: size.height/2)

        // add background

        do {
            backgroundNode.zPosition = -1
            backgroundNode.position = center

            addChild(backgroundNode)
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        showGameScene()
    }

    private func showGameScene() {
        let scene = GameScene(size: size)
        scene.scaleMode = scaleMode

        view?.presentScene(scene, transition: SKTransition.doorsOpenHorizontal(withDuration: 0.5))
    }
}
