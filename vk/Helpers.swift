import Foundation

class Session {
    var token: String?
    var userId: Int?
    
    private init() {}
    
    static let sharedInstance = Session()
}
