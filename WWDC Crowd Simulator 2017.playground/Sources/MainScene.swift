import SpriteKit
import GameKit

public class MainScene: SKScene {
    
    // MARK: Properties
    
    var personTextures = [SKTexture]()
    
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
        
        let logo = SKSpriteNode(imageNamed: "Logo")
        logo.name = "logo"
        logo.setScale(0.25)
        logo.position = CGPoint(x: frame.midX, y: frame.midY)
        logo.physicsBody = SKPhysicsBody(rectangleOf: logo.size)
        addChild(logo)
        
        let button = ButtonNode()
        button.name = "button"
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
        enumerateChildNodes(withName: "person") { (node, stop) in
            if node.position.y < -50 || node.position.y > self.frame.size.height + 50 || node.position.x < -50 || node.position.x > self.frame.size.width + 50 {
                node.removeFromParent()
            }
        }
    }
    
    public override func didChangeSize(_ oldSize: CGSize) {
        // It's like Auto Layout without Auto Layout
        resetLogoPosition()
        guard let button = childNode(withName: "button") else { return }
        button.position = CGPoint(x: frame.width - 50, y: 50)
    }
    
    func resetLogoPosition() {
        guard let logo = childNode(withName: "logo") else { return }
        logo.position = CGPoint(x: frame.midX, y: frame.midY)
        let rotationAction = SKAction.rotate(toAngle: 0, duration: 0)
        logo.run(rotationAction)
    }
    
    // MARK: Touch Handling
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        let location = touches.first!.location(in: self)
        createRandomPerson(at: location)
    }
    
    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        let location = touches.first!.location(in: self)
        createRandomPerson(at: location)
    }
    
    func createRandomPerson(at point: CGPoint) {
        let randomTextureIndex = GKRandomSource.sharedRandom().nextInt(upperBound: personTextures.count)
        
        let person = SKSpriteNode(texture: personTextures[randomTextureIndex])
        person.name = "person"
        person.setScale(0.25)
        person.position = CGPoint(x: point.x, y: point.y)
        
        let maxRadius = max(person.frame.size.width/2, person.frame.size.height/2)
        let interPersonSeparationConstant: CGFloat = 1.25
        person.physicsBody = SKPhysicsBody(circleOfRadius: maxRadius*interPersonSeparationConstant)
        
        addChild(person)
    }
    
}

// MARK: ButtonNodeDelegate

extension MainScene: ButtonNodeDelegate {
    
    func didTapReset(sender: ButtonNode) {
        // Remove all person nodes
        enumerateChildNodes(withName: "person") { (node, stop) in
            node.removeFromParent()
        }
        
        resetLogoPosition()
    }
}
