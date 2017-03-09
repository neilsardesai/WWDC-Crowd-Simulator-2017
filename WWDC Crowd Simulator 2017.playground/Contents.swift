import SpriteKit
import PlaygroundSupport

// Change these values to whatever you want. Only for Xcode (macOS). Changing these values in Swift Playgrounds (iPad) makes no difference.
let width = 480
let height = 540

// Set up containing view
let spriteView = SKView(frame: CGRect(x: 0, y: 0, width: width, height: height))
spriteView.showsDrawCount = true
spriteView.showsNodeCount = true
spriteView.showsFPS = true

// Add main scene
let scene = MainScene(size: CGSize(width: width, height: height))
spriteView.presentScene(scene)

// Show in Playground live view
let page = PlaygroundPage.current
page.liveView = spriteView

