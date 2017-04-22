import Foundation
import UIKit

public class BitItem: NSObject {
    
    public var bitId: String!
    public var panoramaImageURL: String!
    public var bitTitle: String!
    public var bitDescription: String!
    public var personName: String!
    public var personGender: String!
    
    struct BitParameters {
        let ID = "bitId"
        let PANORAMA_URL = "panoramaImageURL"
        let TITLE = "bitTitle"
        let DESCRIPTION = "bitDescription"
        let PERSON = "bitPersonName"
        let GENDER = "bitPersonGender"
    }
    
    override public init () {
        super.init()
    }
    
    convenience public init(_ dictionary: Dictionary<String, String>) {
        self.init()
        
        bitId = dictionary[BitParameters().ID]
        panoramaImageURL = dictionary[BitParameters().PANORAMA_URL]
        bitTitle = dictionary[BitParameters().TITLE]
        bitDescription = dictionary[BitParameters().DESCRIPTION]
        personName = dictionary[BitParameters().PERSON]
        personGender = dictionary[BitParameters().GENDER]

    }
    
}

