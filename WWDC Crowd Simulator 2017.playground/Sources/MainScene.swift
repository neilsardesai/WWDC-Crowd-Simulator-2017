import SpriteKit
import GameKit

public class MainScene: SKScene {
    
    // MARK: Properties
    
    var personTextures = [SKTexture]()
    let logoNodeName = "logo"
    let personNodeName = "person"
    let buttonNodeName = "button"
    
    // MARK: Lifecycle
    
    override public func didMove(to view: SKView) {
        super.didMove(to: view)
        setUpScene()
    }
    
    func setUpScene() {
        // Set up inital view
        backgroundColor = SKColor(red: 248.0/255.0, green: 248.0/255.0, blue: 248.0/255.0, alpha: 1.0)
        scaleMode = .resizeFill
        physicsWorld.gravity = CGVector.zero
        view?.isMultipleTouchEnabled = true
        
        let logo = SKSpriteNode(imageNamed: "Logo")
        logo.name = logoNodeName
        logo.setScale(0.375)
        logo.position = CGPoint(x: frame.midX, y: frame.midY)
        logo.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: logo.size.width * 1.25, height: logo.size.height * 2.5))
        logo.physicsBody?.isDynamic = false
        addChild(logo)
        
        let button = ResetButtonNode()
        button.name = buttonNodeName
        button.position = CGPoint(x: frame.width - 50, y: 50)
        button.delegate = self
        addChild(button)
        
        // Set up person textures
        for i in 0...262 {
            personTextures.append(SKTexture(imageNamed: "Person\(i).png"))
        }
    }
    
    override public func didSimulatePhysics() {
        super.didSimulatePhysics()
        
        // Remove nodes if they're outside the view
        enumerateChildNodes(withName: personNodeName) { (node, stop) in
            if node.position.y < -50 || node.position.y > self.frame.size.height + 50 || node.position.x < -50 || node.position.x > self.frame.size.width + 50 {
                node.removeFromParent()
            }
        }
    }
    
    public override func didChangeSize(_ oldSize: CGSize) {
        // It's like Auto Layout without Auto Layout
        resetLogoPosition()
        resetButtonPosition()
    }
    
    // MARK: Helper Functions
    
    func resetLogoPosition() {
        guard let logo = childNode(withName: logoNodeName) else { return }
        logo.position = CGPoint(x: frame.midX, y: frame.midY)
    }
    
    func resetButtonPosition() {
        guard let button = childNode(withName: buttonNodeName) else { return }
        button.position = CGPoint(x: frame.width - 50, y: 50)
    }
    
    func hideButton() {
        guard let button = childNode(withName: buttonNodeName) else { return }
        let fadeOutAction = SKAction.fadeOut(withDuration: 0.25)
        fadeOutAction.timingMode = .easeInEaseOut
        button.run(fadeOutAction)
    }
    
    func showButton() {
        guard let button = childNode(withName: buttonNodeName) else { return }
        let fadeInAction = SKAction.fadeIn(withDuration: 0.25)
        fadeInAction.timingMode = .easeInEaseOut
        button.run(fadeInAction)
    }
    
    func createRandomPerson(at point: CGPoint) {
        let randomTextureIndex = GKRandomSource.sharedRandom().nextInt(upperBound: personTextures.count)
        
        let person = SKSpriteNode(texture: personTextures[randomTextureIndex])
        person.name = personNodeName
        person.setScale(0.375)
        person.position = CGPoint(x: point.x, y: point.y)
        
        let maxRadius = max(person.frame.size.width/2, person.frame.size.height/2)
        let interPersonSeparationConstant: CGFloat = 1.25
        person.physicsBody = SKPhysicsBody(circleOfRadius: maxRadius*interPersonSeparationConstant)
        
        addChild(person)
    }
    
    // MARK: Touch Handling
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        for touch in touches {
            let location = touch.location(in: self)
            createRandomPerson(at: location)
        }
        hideButton()
    }
    
    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        for touch in touches {
            let location = touch.location(in: self)
            createRandomPerson(at: location)
        }
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        showButton()
    }
    
    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        showButton()
    }
    
}

// MARK: ResetButtonNodeDelegate

extension MainScene: ResetButtonNodeDelegate {
    
    func didTapReset(sender: ResetButtonNode) {
        // Remove all person nodes
        enumerateChildNodes(withName: personNodeName) { (node, stop) in
            let fadeOutAction = SKAction.fadeOut(withDuration: 0.25)
            fadeOutAction.timingMode = .easeInEaseOut
            node.run(fadeOutAction, completion: {
                node.removeFromParent()
            })
        }
    }
}
