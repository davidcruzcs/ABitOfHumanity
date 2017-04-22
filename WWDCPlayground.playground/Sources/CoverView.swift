import Foundation
import UIKit
import SpriteKit

public class CoverView: UIView {
    
    struct ConstraintsCoverView {
        let horizontalMarginHeaderLabel: CGFloat = 60
        let verticalMarginHeaderLabel: CGFloat = 40
        
        let horizontalMarginSubtitle: CGFloat = 60
        let verticalMarginSubtitle: CGFloat = 8
        let heightSubtitle: CGFloat = 25
    }
    
    public var headerTextView: UILabel!
    public var headerSubtitle: UILabel!
    
    var peopleSKView: SKView!
    var peopleSKScene: SKScene!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setBackgroundColor(color: .white)
        setUpPeopleView()
        setHeaderLogo()
        setSubtitleLabel()
        
    }
    
    
    public func setHeaderLogo() {
        
        headerTextView = UILabel()
        
        headerTextView.font =  UIFont(name: "PressStart2P", size: 30)
        headerTextView.numberOfLines = 2
        headerTextView.textColor = .darkGray
        headerTextView.textAlignment = .center
        
        //headerTextView.backgroundColor = .red
        
        headerTextView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(headerTextView)
        
        headerTextView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: ConstraintsCoverView().horizontalMarginHeaderLabel).isActive = true
        headerTextView.topAnchor.constraint(equalTo: self.topAnchor, constant: ConstraintsCoverView().verticalMarginHeaderLabel).isActive = true
        headerTextView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -ConstraintsCoverView().horizontalMarginHeaderLabel).isActive = true
        headerTextView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -ConstraintsCoverView().verticalMarginHeaderLabel).isActive = true
        
        headerTextView.text = "A BIT OF HUMANITY"
        
        
    }
    
    public func setSubtitleLabel() {
        
        
        headerSubtitle = UILabel()
        
        headerSubtitle.font =  UIFont.systemFont(ofSize: 12)
        headerSubtitle.numberOfLines = 1
        headerSubtitle.textColor = .darkGray
        headerSubtitle.textAlignment = .center
        
        headerSubtitle.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(headerSubtitle)
        
        headerSubtitle.leftAnchor.constraint(equalTo: self.leftAnchor, constant: ConstraintsCoverView().horizontalMarginSubtitle).isActive = true
        headerSubtitle.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -ConstraintsCoverView().horizontalMarginSubtitle).isActive = true
        headerSubtitle.topAnchor.constraint(equalTo: headerTextView.bottomAnchor, constant: ConstraintsCoverView().verticalMarginSubtitle).isActive = true
        headerSubtitle.heightAnchor.constraint(equalToConstant: ConstraintsCoverView().heightSubtitle).isActive = true
        
        
        headerSubtitle.text = "We are a 🌎 united by diversity 👨🏽‍🎤👩🏻‍🎨"
        
    }
    
    
    public func setBackgroundColor (color: UIColor) {
        self.backgroundColor = color
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("CircleView is not NSCoding compliant")
    }
    
}

extension CoverView {
    
    func setUpPeopleView() {
        
        peopleSKView = SKView(frame: CGRect(x: -50, y: -50, width: 650, height: 250))
        peopleSKView.showsFPS = false
        peopleSKView.showsNodeCount = false
        
        self.addSubview(peopleSKView)
        
        peopleSKView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        peopleSKView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        peopleSKView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        peopleSKView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        
        
        peopleSKScene  = CoverScene()
        peopleSKScene.size = peopleSKView.bounds.size
        peopleSKScene.scaleMode = .aspectFill
        peopleSKView.presentScene(peopleSKScene)
        
        
    }
    
    
}

