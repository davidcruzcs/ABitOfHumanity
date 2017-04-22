import Foundation
import SpriteKit

public class CoverScene: SKScene {
    
    let colors: [SKColor] = [
        SKColor(colorLiteralRed: 235.0/255.0, green: 71.0/255.0, blue: 86.0/255.0, alpha: 0.5),
        SKColor(colorLiteralRed: 110.0/255.0, green: 203.0/255.0, blue: 226.0/255.0, alpha: 0.5),
        SKColor(colorLiteralRed: 235.0/255.0, green: 220.0/255.0, blue: 53.0/255, alpha: 0.5),
        SKColor(colorLiteralRed: 129.0/255.0, green: 195.0/255.0, blue: 64.0/255, alpha: 0.5),
        SKColor(colorLiteralRed: 247.0/255.0, green: 186.0/255.0, blue: 63.0/255, alpha: 0.5),
        SKColor(colorLiteralRed: 216.0/255.0, green: 106.0/255.0, blue: 169.0/255, alpha: 0.5),
        SKColor(colorLiteralRed: 25.0/255.0, green: 153.0/255.0, blue: 204.0/255, alpha: 0.5),
        SKColor(colorLiteralRed: 105.0/255.0, green: 198.0/255.0, blue: 174.0/255, alpha: 0.5)
    ]
    
    
    override public func didMove(to view: SKView) {
        scene!.backgroundColor = SKColor.white
        for index in 1...60 {
            makePersonInPosition(index: index)
        }
        
    }
    
    
    public func makePersonInPosition(index: Int) {
        
        let randomColor = colors.randomElement
        
        let person = SKShapeNode(rectOf: CGSize(width: randomNumber(bottom: 5, top: 8), height: randomNumber(bottom: 5, top: 8)))
        person.position = CGPoint(x: randomNumber(bottom: 0, top: Int(view!.scene!.frame.width)), y: randomNumber(bottom: 0, top: Int(view!.scene!.frame.height)))
        person.name = "person" + String(index)
        person.fillColor = randomColor
        person.strokeColor = SKColor.clear
        self.addChild(person)
        
        
        let moveRect = SKAction.moveBy(x: view!.scene!.frame.width * CGFloat(randomNumber(bottom: -1, top: 3)) ,y: view!.scene!.frame.height * CGFloat(randomNumber(bottom: -1, top: 3)), duration: 300)

        moveRect.timingMode = .linear
        person.run(moveRect)
        
    }
    
    override public func update(_ currentTime: TimeInterval) {
        
    }
    
    
    func randomNumber(bottom: Int, top:Int) -> Int {
        return Int(arc4random_uniform(UInt32(top))) + bottom
    }
    
    

}

extension Array {
    var randomElement: Element {
        let index = Int(arc4random_uniform(UInt32(count)))
        return self[index]
    }
}
