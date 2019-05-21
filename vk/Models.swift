import Foundation
import RealmSwift
import UIKit

//class User: Codable {
//    var id: Int
//    var first_name: String
//    var last_name: String
//    var photo_uri: String
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case first_name
//        case last_name
//        case photo_uri = "photo_100"
//    }
//}

class BaseUser: Object, Codable {
    @objc dynamic var id: Int = 0
    @objc dynamic var first_name: String = ""
    @objc dynamic var last_name: String = ""
    @objc dynamic var photo_uri: String = ""
    
    enum CodingKeys: String, CodingKey {
        case id
        case first_name
        case last_name
        case photo_uri = "photo_100"
    }
    
    required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        first_name = try container.decode(String.self, forKey: .first_name)
        last_name = try container.decode(String.self, forKey: .last_name)
        photo_uri = try container.decode(String.self, forKey: .photo_uri)
    }
    
    convenience init(_ id: Int, _ first_name: String, _ last_name: String, _ photo_uri: String) {
        self.init()
        self.id = id
        self.first_name = first_name
        self.last_name = last_name
        self.photo_uri = photo_uri
    }
    
        override static func primaryKey() -> String? {
            return "id"
        }
}

class User: BaseUser {
    let friends = List<Friend>()
}

class Friend: BaseUser {
    let friends = LinkingObjects(fromType: User.self, property: "friends")
}


//class BaseRealmUser: Object {
//    @objc dynamic var id: Int = 0
//    @objc dynamic var first_name: String = ""
//    @objc dynamic var last_name: String = ""
//    @objc dynamic var photo_uri: String = ""
//
//    override static func primaryKey() -> String? {
//        return "id"
//    }
//}
//
//class RealmUser: BaseRealmUser {
//    let friends = List<RealmFriend>()
//}
//
//class RealmFriend: BaseRealmUser {
//    let friends = LinkingObjects(fromType: RealmUser.self, property: "friends")
//}

class VkResponse {
    enum CodingKeys: String, CodingKey {
        case response
    }
}

class VkListResponse: VkResponse {
    
    enum ResponseKeys: String, CodingKey {
        case count
        case items
    }
}

class UserResponse: VkResponse, Decodable {
    var user: User?
    
    convenience required init(from decoder: Decoder) throws {
        self.init()
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        var responseContainer = try container.nestedUnkeyedContainer(forKey: .response)
        self.user = try responseContainer.decode(User.self)
    }
}

class UsersResponse: VkListResponse, Decodable {
    var list = [User] ()

    convenience required init(from decoder: Decoder) throws {
        self.init()

        let container = try decoder.container(keyedBy: CodingKeys.self)
        let responseContainer = try container.nestedContainer(keyedBy: ResponseKeys.self, forKey: .response)
        let users = try responseContainer.decode([User].self, forKey: .items)
        list.append(contentsOf: users)
    }
}

class FriendsResponse: VkListResponse, Decodable {
    var list = [Friend] ()
    
    convenience required init(from decoder: Decoder) throws {
        self.init()
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let responseContainer = try container.nestedContainer(keyedBy: ResponseKeys.self, forKey: .response)
        let friends = try responseContainer.decode([Friend].self, forKey: .items)
        list.append(contentsOf: friends)
    }
}

class Group: Object, Codable {
    @objc dynamic var id: Int
    @objc dynamic var name: String
    @objc dynamic var image_uri: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case image_uri = "photo_100"
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

class GroupsResponse: VkListResponse, Decodable {
    var list = [Group] ()
    
    required convenience init(from decoder: Decoder) throws {
        self.init()
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let responseContainer = try container.nestedContainer(keyedBy: ResponseKeys.self, forKey: .response)
        let groups = try responseContainer.decode([Group].self, forKey: .items)
        list.append(contentsOf: groups)
    }
}

class Photo: Object, Decodable {
    @objc dynamic var id: Int = 0
    @objc dynamic var album_id: Int = 0
    @objc dynamic var uri: String = ""
    @objc dynamic var text: String = ""
    @objc dynamic var date: Int = 0
    
    enum CodingKeys: String, CodingKey {
        case id
        case album_id
        case uri
        case text
        case date
        case sizes
    }
    
    enum SizesKeys: String, CodingKey {
        case type
        case url
    }
    
    required convenience init(from decoder: Decoder) throws {
        self.init()
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(Int.self, forKey: .id)
        self.album_id = try container.decode(Int.self, forKey: .album_id)
        self.text = try container.decode(String.self, forKey: .text)
        self.date = try container.decode(Int.self, forKey: .date)
        
        var sizesContainer = try container.nestedUnkeyedContainer(forKey: .sizes)
        while (!sizesContainer.isAtEnd) {
            let sizeContainer = try sizesContainer.nestedContainer(keyedBy: SizesKeys.self)
            let type = try sizeContainer.decode(String.self, forKey: .type)
            if type == "x" {
                self.uri = try sizeContainer.decode(String.self, forKey: .url)
                break
            }
        }
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

class PhotosResponse: VkListResponse, Decodable {
    var list = [Photo] ()
    
    required convenience init(from decoder: Decoder) throws {
        self.init()
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let responseContainer = try container.nestedContainer(keyedBy: ResponseKeys.self, forKey: .response)
        let photos = try responseContainer.decode([Photo].self, forKey: .items)
        list.append(contentsOf: photos)
    }
}

struct News: Equatable {
    let text: String
    let image: UIImage?
    let views: Int
}
