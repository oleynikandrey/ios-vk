import Foundation
import Alamofire

class Session {
    var token: String?
    var userId: Int?
    
    private init() {}
    
    static let sharedInstance = Session()
}

class VKAPIClient{
    let access_token: String
    let base_uri = "https://api.vk.com/method/"
    let version = "5.95"
    var params: Parameters
    
    init(access_token: String) {
        self.access_token = access_token
        
        params = [
            "access_token": access_token,
            "version": version
        ]
    }
    
    func get_profile() {
        Alamofire.request(base_uri + "users.get", method: .get, parameters: params).responseJSON { response in
            print(response.value ?? "No info")
        }
    }
    
    func get_friends() {
        Alamofire.request(base_uri + "friends.get", method: .get, parameters: params).responseJSON { response in
            print(response.value ?? "No info")
        }
    }
    
    func get_photos(album_id: String = "profile") {
        var _params = params
        _params["album_id"] = album_id
        
        Alamofire.request(base_uri + "photos.get", method: .get, parameters: _params).responseJSON { response in
            print(response.value ?? "No info")
        }
    }
    
    func get_groups() {
        Alamofire.request(base_uri + "groups.get", method: .get, parameters: params).responseJSON { response in
            print(response.value ?? "No info")
        }
    }
    
    func find_groups(query: String) {
        var _params = params
        _params["q"] = query
        
        Alamofire.request(base_uri + "groups.search", method: .get, parameters: _params).responseJSON { response in
            print(response.value ?? "No info")
        }

    }
    
}
