import Foundation
import UIKit

public class UICollectionInfoCell: UICollectionViewCell {

    public var label: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        addViews()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addViews() {
        
        label.textAlignment = .center
        
        addSubview(label)
        label.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        label.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        label.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
        
    }
    

}
