import Foundation
import RealmSwift

let ACCESS_TOKEN = "accessToken"

class Session {
    var token: String?
    var userId: Int?
    
    private init() {}
    
    static let sharedInstance = Session()
}

class VKAPIClient{
    let access_token: String
    let version = "5.95"
    
    private lazy var session: URLSession = {
        let configuration = URLSessionConfiguration.default
        return URLSession(configuration: configuration)
    }()
    
    private lazy var urlComponents: URLComponents = {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.vk.com"
        components.path = "/method/"
        components.queryItems = [
            URLQueryItem(name: "access_token", value: access_token),
            URLQueryItem(name: "v", value: version),
        ]
        return components
    }()
    
    init(access_token: String) {
        self.access_token = access_token
    }
    
    func getProfile(completionHandler: @escaping (User) -> Void ) {
        var components = urlComponents
        components.path += "users.get"
        components.queryItems?.append(URLQueryItem(name: "fields", value: "photo_100"))
        
        let task = session.dataTask(with: components.url!) { data, response, error in
            if let error = error {
                print(error)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200,
                let data = data else {
                    return
            }
            
            do {
                if let user = try JSONDecoder().decode(UserResponse.self, from: data).user {
                    DispatchQueue.main.async() {
                        completionHandler(user)
                    }
                }
                
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    
    func getFriends(completionHandler: @escaping ([Friend]) -> Void ) {
        var components = urlComponents
        components.path += "friends.get"
        components.queryItems?.append(URLQueryItem(name: "fields", value: "nickname,photo_100"))
        
        let task = session.dataTask(with: components.url!) { data, response, error in
            if let error = error {
                print(error)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200,
                let data = data else {
                    return
            }
            
            do {
                let friends = try JSONDecoder().decode(FriendsResponse.self, from: data).list
                DispatchQueue.main.async() {
                    completionHandler(friends)
                }
                
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    
    func getPhotos(album_id: String = "profile", completionHandler: @escaping ([Photo]) -> Void ) {
        var components = urlComponents
        components.path += "photos.get"
        components.queryItems?.append(URLQueryItem(name: "album_id", value: album_id))
        
        let task = session.dataTask(with: components.url!) { data, response, error in
            if let error = error {
                print(error)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200,
                let data = data else {
                    return
            }
            
            do {
                let photos = try JSONDecoder().decode(PhotosResponse.self, from: data).list
                DispatchQueue.main.async() {
                    completionHandler(photos)
                }
                
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    
    func getGroups(completionHandler: @escaping ([Group]) -> Void ) {
        var components = urlComponents
        components.path += "groups.get"
        components.queryItems?.append(URLQueryItem(name: "extended", value: "1"))
        
        let task = session.dataTask(with: components.url!) { data, response, error in
            if let error = error {
                print(error)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200,
                let data = data else {
                    return
            }
            
            do {
                let groups = try JSONDecoder().decode(GroupsResponse.self.self, from: data).list
                DispatchQueue.main.async() {
                    completionHandler(groups)
                }
                
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    
    func findGroups(query: String, completionHandler: @escaping ([Group]) -> Void ) {
        var components = urlComponents
        components.path += "groups.search"
        components.queryItems?.append(URLQueryItem(name: "q", value: query))
        
        let task = session.dataTask(with: components.url!) { data, response, error in
            if let error = error {
                print(error)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200,
                let data = data else {
                    return
            }
            
            do {
                let groups = try JSONDecoder().decode(GroupsResponse.self.self, from: data).list
                DispatchQueue.main.async() {
                    completionHandler(groups)
                }
                
            } catch {
                print(error)
            }
        }
        task.resume()
        
    }
}

class VKDao {
    
    class func saveUserData(_ user: User) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(user, update: true)
            }
        } catch {
            print(error)
        }
    }
    
    class func saveFriendsData(user_id: Int, friends: [Friend]) {
        do {
            let realm = try Realm()
            guard let user = realm.object(ofType: User.self, forPrimaryKey: user_id) else {
                return
            }
            try realm.write {
                for friend in friends {
                    if let realmFriend = realm.object(ofType: Friend.self, forPrimaryKey: friend.id) {
                        user.friends.append(realmFriend)
                    } else {
                        user.friends.append(friend)
                    }
                }
                realm.add(user, update: true)
            }
        } catch {
            print(error)
        }
    }
    
    class func loadFriendsData() -> [Friend] {
        do {
            let realm = try Realm()
            let friends = realm.objects(Friend.self).sorted(byKeyPath: "first_name")
            return Array(friends)
            
        } catch {
            print(error)
            return []
        }
    }
    
    class func clean() {
        do {
            let realm = try Realm()
            try realm.write {
                realm.deleteAll()
            }
        } catch {
            print(error)
        }
    }
}
