import Foundation
import SpriteKit
import AVFoundation

final class GameScene5: BaseScene {
    private lazy var videoItem = AVPlayerItem(url: Bundle.main.url(forResource: "discolights-loop", withExtension: "mov")!)
    private lazy var videoPlayer = AVQueuePlayer(items: [])
    private lazy var looper = AVPlayerLooper(player: videoPlayer, templateItem: videoItem)
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        do {
            let videoNode = SKVideoNode(avPlayer: videoPlayer)
            videoNode.zPosition = -1
            videoNode.size = size
            videoNode.anchorPoint = .zero
            videoNode.position = .zero
            
            addChild(videoNode)
        }
        
        _ = looper
        
        videoPlayer.play()
    }
    override func restart() {
        let scene = SKScene(fileNamed: "GameScene5")
        scene?.scaleMode = scaleMode
        view?.presentScene(scene)
    }
}
