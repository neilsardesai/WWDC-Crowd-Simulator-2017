import SpriteKit
import GameKit

public class MainScene: SKScene {
    
    var hasContentCreated = false
    var personTextures = [SKTexture]()
    
    override public func didMove(to view: SKView) {
        super.didMove(to: view)
        if !hasContentCreated {
            setUpScene()
            hasContentCreated = true
        }
    }
    
    func setUpScene() {
        // Set up inital view
        backgroundColor = SKColor(red: 248.0/255.0, green: 248.0/255.0, blue: 248.0/255.0, alpha: 1.0)
        scaleMode = .aspectFill
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        
        let logo = SKSpriteNode(imageNamed: "Logo")
        logo.setScale(0.25)
        logo.position = CGPoint(x: frame.midX, y: frame.midY)
        logo.physicsBody = SKPhysicsBody(rectangleOf: logo.size)
        addChild(logo)
        
        // Set up person textures
        for i in 0...262 {
            personTextures.append(SKTexture(imageNamed: "Person\(i).png"))
        }
    }
    
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
    
    override public func didSimulatePhysics() {
        super.didSimulatePhysics()
        
        // Remove nodes if they're outside the view
        enumerateChildNodes(withName: "person") { (node, stop) in
            if node.position.y < -50 || node.position.y > self.frame.size.height + 50 || node.position.x < -50 || node.position.x > self.frame.size.width + 50 {
                node.removeFromParent()
            }
        }
    }
    
}
