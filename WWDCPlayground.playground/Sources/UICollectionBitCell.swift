import Foundation
import UIKit

public class UICollectionBitCell: UICollectionViewCell {
    
    struct CornerConstants {
        let size: CGFloat = 15
    }
    
    public var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .white
        imageView.image = UIImage(named: "Background")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        addSquareBorders()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addViews() {
        
        backgroundColor = UIColor.white
        
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(backgroundImageView)
        backgroundImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        backgroundImageView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        backgroundImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
        backgroundImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.clipsToBounds = true
        
        
    }
    
    func addSquareBorders() {
        
        let firstCorner = UIView()
        firstCorner.backgroundColor = UIColor(white: 0.97, alpha: 1.0)
        firstCorner.translatesAutoresizingMaskIntoConstraints = false
        addSubview(firstCorner)
        firstCorner.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        firstCorner.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        firstCorner.heightAnchor.constraint(equalToConstant: CornerConstants().size).isActive = true
        firstCorner.widthAnchor.constraint(equalToConstant: CornerConstants().size).isActive = true
        
        let secondCorner = UIView()
        secondCorner.backgroundColor = UIColor(white: 0.97, alpha: 1.0)
        secondCorner.translatesAutoresizingMaskIntoConstraints = false
        addSubview(secondCorner)
        secondCorner.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
        secondCorner.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        secondCorner.heightAnchor.constraint(equalToConstant: CornerConstants().size).isActive = true
        secondCorner.widthAnchor.constraint(equalToConstant: CornerConstants().size).isActive = true
        
        let thirdCorner = UIView()
        thirdCorner.backgroundColor = UIColor(white: 0.97, alpha: 1.0)
        thirdCorner.translatesAutoresizingMaskIntoConstraints = false
        addSubview(thirdCorner)
        thirdCorner.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        thirdCorner.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        thirdCorner.heightAnchor.constraint(equalToConstant: CornerConstants().size).isActive = true
        thirdCorner.widthAnchor.constraint(equalToConstant: CornerConstants().size).isActive = true
        
        let fourthCorner = UIView()
        fourthCorner.backgroundColor = UIColor(white: 0.97, alpha: 1.0)
        fourthCorner.translatesAutoresizingMaskIntoConstraints = false
        addSubview(fourthCorner)
        fourthCorner.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
        fourthCorner.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        fourthCorner.heightAnchor.constraint(equalToConstant: CornerConstants().size).isActive = true
        fourthCorner.widthAnchor.constraint(equalToConstant: CornerConstants().size).isActive = true
        
    }
    
}
