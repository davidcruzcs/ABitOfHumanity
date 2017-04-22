import Foundation
import UIKit
import CoreMotion
import QuartzCore



public protocol PanoramaViewDelegate: class {
    func didSelectedCloseButton(sender: PanoramaView)
    func didSelectedNextBit(sender: PanoramaView)
    func didSelectedPreviousBit(sender: PanoramaView)
}

public class PanoramaView: UIView {
    
    public weak var delegate:PanoramaViewDelegate?
    
    var panoramaImageView = UIImageView()
    
    var currentBit: BitItem!
    
    var titleView = UIView()
    var titleLabel = UILabel()
    var closeButton = UIButton()
    
    var nextButton = UIButton()
    var previousButton = UIButton()
    
    var descriptionView = UIView()
    var descriptionTitleLabel = UILabel()
    var descriptionTextView = UITextView()
    
    var guideImageView = UIImageView()
    
    let motionManager: CMMotionManager = CMMotionManager()
    
    var xCurrentValue: Double = 0.0
    var yCurrentValue: Double = 0.0
    
    var screenSize: CGRect!
    
    var minXValue: Double!
    var minYValue: Double!
    var maxXValue: Double!
    var maxYValue: Double!
    
    struct PositionConstants {
        let FIRST = "FIRST"
        let LAST = "LAST"
        let MIDDLE = "MIDDLE"
    }
    
    struct PanoramaImageConstraints {
        let imageHeight: Double = 650
        let imageWidth: Double = 2918
    }
    
    struct TitleViewConstraints {
        let height: CGFloat = 64
    }
    
    struct DescriptionViewConstants {
        let height: CGFloat = 120
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        let fontURL: CFURL = Bundle.main.url(forResource: "PressStart2P", withExtension: "ttf")! as CFURL
        CTFontManagerRegisterFontsForURL(fontURL , CTFontManagerScope.process, nil)
        
        setPanoramaView()
        setUpTitleView()
        setDescriptionView()
        setInstructionView()
        setPositionView()
        setDefaultValues()
        
        
    }
    
    func setDefaultValues() {
        
        screenSize = self.bounds
        
        xCurrentValue = Double(screenSize.width)/2.0
        yCurrentValue = Double(screenSize.height)/2.0
        self.panoramaImageView.center = CGPoint(x: xCurrentValue, y: yCurrentValue)
        
        let xVariation = (PanoramaImageConstraints().imageWidth - Double(screenSize.width))/2
        let yVariation = (PanoramaImageConstraints().imageHeight - Double(screenSize.height))/2
        
        minXValue = xCurrentValue - xVariation
        minYValue = yCurrentValue - yVariation
        
        maxXValue = xCurrentValue + xVariation
        maxYValue = yCurrentValue + yVariation
        
        
    }
    
    func setPanoramaView() {
        
        self.backgroundColor = UIColor(white: 0.1, alpha: 1.0)
        
        panoramaImageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(panoramaImageView)
        
        panoramaImageView.widthAnchor.constraint(equalToConstant: CGFloat(PanoramaImageConstraints().imageWidth)).isActive = true
        panoramaImageView.heightAnchor.constraint(equalToConstant: CGFloat(PanoramaImageConstraints().imageHeight)).isActive = true
        panoramaImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: CGFloat(xCurrentValue)).isActive  = true
        panoramaImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0)
        
        panoramaImageView.contentMode = .scaleAspectFill
        panoramaImageView.clipsToBounds = true
        
    }
    
    func setUpTitleView() {
        
        titleView.backgroundColor = UIColor(white: 0, alpha: 0.7)
        titleView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(titleView)
        
        titleView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        titleView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        titleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        titleView.heightAnchor.constraint(equalToConstant: TitleViewConstraints().height).isActive = true
        
        
        closeButton.setTitle("X", for: .normal)
        closeButton.setTitleColor(.white, for: .normal)
        closeButton.titleLabel?.font = UIFont(name: "PressStart2P", size: 15)
        closeButton.addTarget(self, action: #selector(closePanoramaView), for: .touchUpInside)
        
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        titleView.addSubview(closeButton)
        
        closeButton.topAnchor.constraint(equalTo: titleView.topAnchor, constant: 8).isActive = true
        closeButton.rightAnchor.constraint(equalTo: titleView.rightAnchor, constant: -20).isActive = true
        closeButton.bottomAnchor.constraint(equalTo: titleView.bottomAnchor, constant: -8).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        
        titleLabel.textColor = .white
        titleLabel.font =  UIFont(name: "PressStart2P", size: 15)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleView.addSubview(titleLabel)
        
        titleLabel.leftAnchor.constraint(equalTo: titleView.leftAnchor, constant: 20).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: closeButton.leftAnchor, constant: -20).isActive = true
        titleLabel.topAnchor.constraint(equalTo: titleView.topAnchor, constant: 8).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: titleView.bottomAnchor, constant: -8).isActive = true
        
    }
    
    func setPositionView() {
        
        previousButton.setTitle("<", for: .normal)
        previousButton.setTitleColor(.white, for: .normal)
        previousButton.titleLabel?.font = UIFont(name: "PressStart2P", size: 18)
        previousButton.addTarget(self, action: #selector(previousBit), for: .touchUpInside)
        previousButton.isHidden = true
        previousButton.backgroundColor = UIColor(white: 0, alpha: 0.7)
        
        previousButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(previousButton)
        
        previousButton.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        previousButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        previousButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        previousButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        
        previousButton.layer.cornerRadius = previousButton.frame.size.width/2
        previousButton.layer.masksToBounds = true
        
        
        nextButton.setTitle(">", for: .normal)
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.titleLabel?.font = UIFont(name: "PressStart2P", size: 18)
        nextButton.addTarget(self, action: #selector(nextBit), for: .touchUpInside)
        nextButton.isHidden = true
        nextButton.backgroundColor = UIColor(white: 0, alpha: 0.7)
        
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(nextButton)
        
        nextButton.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        nextButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        nextButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        
        nextButton.layer.cornerRadius = nextButton.frame.size.width/2
        nextButton.layer.masksToBounds = true
        
    }
    
    
    func setDescriptionView() {
        
        descriptionView.backgroundColor = UIColor(white: 0, alpha: 0.7)
        
        descriptionView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(descriptionView)
        
        descriptionView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        descriptionView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        descriptionView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        descriptionView.heightAnchor.constraint(equalToConstant: DescriptionViewConstants().height).isActive = true
        
        
        descriptionTitleLabel.textColor = .white
        descriptionTitleLabel.textAlignment = .center
        
        descriptionTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionView.addSubview(descriptionTitleLabel)
        descriptionTitleLabel.topAnchor.constraint(equalTo: descriptionView.topAnchor, constant: 8).isActive = true
        descriptionTitleLabel.leftAnchor.constraint(equalTo: descriptionView.leftAnchor, constant: 8).isActive = true
        descriptionTitleLabel.rightAnchor.constraint(equalTo: descriptionView.rightAnchor, constant: -8).isActive = true
        descriptionTitleLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        descriptionTextView.textColor = .white
        descriptionTextView.backgroundColor = .clear
        descriptionTextView.isEditable = false
        descriptionTextView.textAlignment = .justified
        
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        descriptionView.addSubview(descriptionTextView)
        
        descriptionTextView.leftAnchor.constraint(equalTo: descriptionView.leftAnchor, constant: 8).isActive = true
        descriptionTextView.rightAnchor.constraint(equalTo: descriptionView.rightAnchor, constant: -8).isActive = true
        descriptionTextView.topAnchor.constraint(equalTo: descriptionTitleLabel.bottomAnchor, constant: 0).isActive = true
        descriptionTextView.bottomAnchor.constraint(equalTo: descriptionView.bottomAnchor, constant: -8).isActive = true
        
    }
    
    func setInstructionView() {
        
        guideImageView = UIImageView()
        
        guideImageView.backgroundColor = UIColor(white: 0, alpha: 0.3)
        
        guideImageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(guideImageView)
        
        
        
        guideImageView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 0).isActive = true
        guideImageView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        guideImageView.heightAnchor.constraint(equalToConstant: 50)
        guideImageView.widthAnchor.constraint(equalToConstant: 100)
        
        guideImageView.contentMode = .scaleAspectFit
        
        guideImageView.image = UIImage(named: "Guide.png")
        
        
        
    }
    
    
    public func setBitObject(item: BitItem, position: String) {
        
        setDefaultValues()
        
        currentBit = item
        
        panoramaImageView.image = UIImage(named: currentBit.panoramaImageURL)
        
        titleLabel.text = currentBit.bitTitle.uppercased()
        
        descriptionTitleLabel.text = currentBit.personName
        
        descriptionTextView.text = currentBit.bitDescription
        
        switch position {
        case PositionConstants().FIRST:
            previousButton.isHidden = true
            nextButton.isHidden = false
        case PositionConstants().MIDDLE:
            previousButton.isHidden = false
            nextButton.isHidden = false
        case PositionConstants().LAST:
            previousButton.isHidden = false
            nextButton.isHidden = true
        default:
            previousButton.isHidden = true
            nextButton.isHidden = true
        }
        
    }
    
    
    public func setUpGyroscope() {
        
        if motionManager.isGyroAvailable {
            
            motionManager.gyroUpdateInterval = 0.02
            motionManager.startGyroUpdates(to: OperationQueue.current!) { (data, error) in
                if let gyroData = data {
                    
                    if self.screenSize.width < self.screenSize.height {
                        //iPad Landscape
                        self.xCurrentValue = self.xCurrentValue + gyroData.rotationRate.x * 20
                        self.yCurrentValue = self.yCurrentValue + gyroData.rotationRate.y * -20
                    } else {
                        //iPad Portrait
                        self.xCurrentValue = self.xCurrentValue + gyroData.rotationRate.y * 20
                        self.yCurrentValue = self.yCurrentValue + gyroData.rotationRate.x * 20
                    }
                    
                    if  self.xCurrentValue < self.minXValue {
                        self.xCurrentValue = self.minXValue
                    }
                    
                    if self.xCurrentValue > self.maxXValue {
                        self.xCurrentValue = self.maxXValue
                    }
                    
                    if self.yCurrentValue < self.minYValue {
                        self.yCurrentValue = self.minYValue
                    }
                    
                    if self.yCurrentValue > self.maxYValue {
                        self.yCurrentValue = self.maxYValue
                    }
                    
                    self.panoramaImageView.center = CGPoint(x: self.xCurrentValue, y: self.yCurrentValue)
                    
                }
            }
        } else {
            print("Gyroscope is encouraged :(. Please try to run on a real iPad :D")
        }
        
    }
    
    func closePanoramaView() {
        delegate?.didSelectedCloseButton(sender: self)
    }
    
    func nextBit() {
        delegate?.didSelectedNextBit(sender: self)
    }
    
    func previousBit() {
        delegate?.didSelectedPreviousBit(sender: self)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("CircleView is not NSCoding compliant")
    }
    
}
