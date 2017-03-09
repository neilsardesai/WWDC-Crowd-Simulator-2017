import SpriteKit

public class ButtonNode: SKSpriteNode {
    
    init() {
        let texture = SKTexture(imageNamed: "Button")
        let color = SKColor.red
        let size = CGSize(width: 41, height: 41)
        super.init(texture: texture, color: color, size: size)
        
        isUserInteractionEnabled = true
        zPosition = 1
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Touch Handling
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        alpha = 0.5
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        
        let location = touches.first!.location(in: self)
        if location.isInside(node: self) {
            let alphaAction = SKAction.fadeAlpha(to: 0.5, duration: 0.10)
            alphaAction.timingMode = .easeInEaseOut
            run(alphaAction)
        }
        else {
            let alphaAction = SKAction.fadeAlpha(to: 1.0, duration: 0.10)
            alphaAction.timingMode = .easeInEaseOut
            run(alphaAction)
        }
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        let alphaAction = SKAction.fadeAlpha(to: 1.0, duration: 0.10)
        alphaAction.timingMode = .easeInEaseOut
        run(alphaAction)
        
        let location = touches.first!.location(in: self)
        if location.isInside(node: self) {
            // Touch Up Inside
        }
    }
    
}

extension CGPoint {
    
    func isInside(node: SKSpriteNode) -> Bool {
        if self.x > -node.size.width/2, self.x < node.size.width/2, self.y > -node.size.height/2, self.y < node.size.height/2 { return true }
        return false
    }
}
