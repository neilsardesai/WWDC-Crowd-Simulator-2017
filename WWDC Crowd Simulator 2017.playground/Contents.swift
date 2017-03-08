import SpriteKit
import PlaygroundSupport

// Set up containing view
let spriteView = SKView(frame: CGRect(x: 0, y: 0, width: 480, height: 270))
spriteView.showsDrawCount = true
spriteView.showsNodeCount = true
spriteView.showsFPS = true

// Add main scene
let scene = MainScene(size: CGSize(width: 480, height: 270))
spriteView.presentScene(scene)

// Show in Playground live view
let page = PlaygroundPage.current
page.liveView = spriteView
