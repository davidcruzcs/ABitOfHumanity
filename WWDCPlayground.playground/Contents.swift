//: A Bit Of Humanity: V0.109.0 - Building

import UIKit
import PlaygroundSupport
import CoreMotion
import AVFoundation


class MainViewController: UIViewController, UIGestureRecognizerDelegate {
    
    let speechSynthesizer = AVSpeechSynthesizer()
    
    var player: AVAudioPlayer?
    
    var collectionBits: UICollectionView!
    var coverView: CoverView!
    
    var panoramaView =  PanoramaView()
    
    var bits = [BitItem]()
    var selectedBitIndex: Int = -1
    
    var informationStrings = [
        ["What's your story?", UIFont.systemFont(ofSize: 15)],
        ["Made with ❤️ in Colombia 🇨🇴", UIFont.systemFont(ofSize: 10)],
        ["Supported Device Orientations: Landscape Right (Home button right)", UIFont.systemFont(ofSize: 8)],
        ["All the people in the photos approved the use of their identity", UIFont.systemFont(ofSize: 8)]
    ]
    
    struct PositionConstants {
        let FIRST = "FIRST"
        let LAST = "LAST"
        let MIDDLE = "MIDDLE"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setMainView()
        setCoverView()
        setBits()
        setCollectionView()
        setUpPanoramaView()
        setUpAVSpeech()
        
    }
    
    func setMainView() {
        
        self.view.backgroundColor = UIColor.darkGray
        
        let fontURL: CFURL = Bundle.main.url(forResource: "PressStart2P", withExtension: "ttf")! as CFURL
        CTFontManagerRegisterFontsForURL(fontURL , CTFontManagerScope.process, nil)
        
        
    }
    
    func setCoverView() {
        
        coverView = CoverView()
        coverView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(coverView)
        
        coverView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        coverView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        coverView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        
        coverView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        
        
        
    }
    
    
    
    func setCollectionView() {
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
     
        
        collectionBits = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionBits.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(collectionBits)
        
        collectionBits.collectionViewLayout = layout
        collectionBits.register(UICollectionBitCell.self, forCellWithReuseIdentifier: "Cell")
        collectionBits.register(UICollectionInfoCell.self, forCellWithReuseIdentifier: "CellInfo")
        collectionBits.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "FooterView")
        
        collectionBits.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        collectionBits.topAnchor.constraint(equalTo: coverView.bottomAnchor, constant: 0).isActive = true
        collectionBits.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        collectionBits.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        
        collectionBits.delegate = self
        collectionBits.dataSource = self
        
        collectionBits.backgroundColor = UIColor(white: 0.97, alpha: 1.0)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return bits.count
        } else {
            return informationStrings.count
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            let cell: UICollectionBitCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! UICollectionBitCell
            
            let currentBit = bits[indexPath.item]
            
            cell.backgroundImageView.image = UIImage(named: currentBit.panoramaImageURL)
            
            return cell
            
        } else {
            let cell: UICollectionInfoCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellInfo", for: indexPath) as! UICollectionInfoCell
            
            let currentString = informationStrings[indexPath.item][0] as! String
            let currentFont = informationStrings[indexPath.item][1] as! UIFont
            
            cell.label.text = currentString
            cell.label.font = currentFont
            
            cell.isUserInteractionEnabled = false
            
            return cell
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            selectedBitIndex = indexPath.item
            panoramaView.setBitObject(item: bits[selectedBitIndex], position: getBitPosition(index: selectedBitIndex))
            panoramaView.isHidden = false
            speakBitInformation(bit: bits[selectedBitIndex])
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: 100, height: 100)
        } else {
            return CGSize(width: 300, height: 20)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        var reusableView: UICollectionReusableView? = nil
        if kind == UICollectionElementKindSectionFooter {
            
            reusableView = collectionBits.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "FooterView", for: indexPath)
            
            
            if reusableView == nil {
                reusableView = UICollectionReusableView(frame: CGRect(x: 0, y: 0, width: collectionBits.frame.size.width, height: 100))
            }
            
            reusableView?.backgroundColor = .red
            
            let labelFooter = UILabel(frame: reusableView!.frame)
            labelFooter.text = "TEST"
            reusableView!.addSubview(labelFooter)
            
        }
        return reusableView!
    }
   
}

extension MainViewController {
    
    
    func setUpPanoramaView() {
        panoramaView.translatesAutoresizingMaskIntoConstraints = false
        panoramaView.delegate = self
        self.view.addSubview(panoramaView)
        panoramaView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        panoramaView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        panoramaView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        panoramaView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        
        
        let gestureRecognizerLeft = UISwipeGestureRecognizer(target: self, action: #selector(didSelectedNextBit))
        gestureRecognizerLeft.direction = .left
        gestureRecognizerLeft.delegate = self
        
        panoramaView.addGestureRecognizer(gestureRecognizerLeft)
        
        let gestureRecognizerRight = UISwipeGestureRecognizer(target: self, action: #selector(didSelectedPreviousBit))
        gestureRecognizerRight.direction = .right
        gestureRecognizerRight.delegate = self
        
        panoramaView.addGestureRecognizer(gestureRecognizerRight)
        
        
        let gestureRecognizerDown = UISwipeGestureRecognizer(target: self, action: #selector(didSelectedCloseButton))
        gestureRecognizerDown.direction = .down
        gestureRecognizerDown.delegate = self
        
        panoramaView.addGestureRecognizer(gestureRecognizerDown)
        
        
        panoramaView.setUpGyroscope()
        panoramaView.isHidden = true
        
    }
    
    func setBits() {
        
        if let path = Bundle.main.path(forResource: "bits", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                if let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? Dictionary<String, Any> {
                    if let bitsArray = jsonResult["bits"] as? Array<Dictionary<String, Any>> {
                        for currentBitItem in bitsArray {
                            let newBit = BitItem(currentBitItem as! Dictionary<String, String>)
                            bits.append(newBit)
                        }
                    }
                }
                
            } catch let error {
                print(error.localizedDescription)
            }
        } else {
            print("Invalid filename/path.")
        }
        
    }

}

extension MainViewController: PanoramaViewDelegate {
    
    func didSelectedCloseButton(sender: PanoramaView) {
        panoramaView.isHidden = true
        stopSpeech(sender: sender)
        selectedBitIndex = -1
    }
    
    func didSelectedNextBit(sender: PanoramaView) {
        if selectedBitIndex+1 < bits.count {
            selectedBitIndex = selectedBitIndex + 1
            panoramaView.setBitObject(item: bits[selectedBitIndex], position: getBitPosition(index: selectedBitIndex))
            speakBitInformation(bit: bits[selectedBitIndex])
        }
    }
    
    func didSelectedPreviousBit(sender: PanoramaView) {
        if selectedBitIndex > 0 {
            selectedBitIndex = selectedBitIndex - 1
            panoramaView.setBitObject(item: bits[selectedBitIndex], position: getBitPosition(index: selectedBitIndex))
            speakBitInformation(bit: bits[selectedBitIndex])
        }
    }
    
    func getBitPosition(index: Int) -> String {
        var position: String!
        switch index {
        case 0:
            position = PositionConstants().FIRST
        case bits.count-1:
            position = PositionConstants().LAST
        default:
            position = PositionConstants().MIDDLE
        }
        return position
    }
}

extension MainViewController: AVSpeechSynthesizerDelegate {
    
    func setUpAVSpeech() {
        
        speechSynthesizer.delegate = self
        sayGreetingMessage()
        
    }
    
    func sayGreetingMessage() {
        
        let speechUtterance = AVSpeechUtterance(string: "Welcome to A Bit of Humanity, an app that shows a little of my country's diversity and its interaction with dreams and technology.")
        
        speechUtterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        if UIAccessibilityIsVoiceOverRunning() == true {
            speechUtterance.preUtteranceDelay = 1.30
        }
        speechSynthesizer.speak(speechUtterance)
        
    }
    
    func speakBitInformation(bit: BitItem) {
        stopSpeech(sender: bit)
        
        if bit.personGender == "Me" {
            playMyVoice()
        } else {
        
            let speechUtterance = AVSpeechUtterance(string: "I am " + bit.personName + ". I am a " + bit.bitTitle + ". " + bit.bitDescription)
            
            var voice = AVSpeechSynthesisVoice(language: "en-US")
            if bit.personGender == "Man" {
                voice = AVSpeechSynthesisVoice(language: "en-GB")
            }
            speechUtterance.voice = voice
            speechSynthesizer.speak(speechUtterance)
            
        }
        
    }
    
    func playMyVoice() {
        let url = URL(fileURLWithPath:Bundle.main.path(forResource: "MyVoice.mp3", ofType: nil)!)
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            guard let player = player else { return }
            
            player.prepareToPlay()
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    
    
    func pauseSpeech(sender: Any) {
        speechSynthesizer.pauseSpeaking(at: AVSpeechBoundary.word)
    }
    
    
    func stopSpeech(sender: Any) {
        if speechSynthesizer.isSpeaking == true {
            speechSynthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
        }
        
        if let playing = player?.isPlaying {
            if playing {
                player?.stop()
            }
        }
        
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        
    }

    
}

var mainController = MainViewController()

PlaygroundPage.current.liveView = mainController
PlaygroundPage.current.needsIndefiniteExecution = true


