import Foundation
import RealmSwift
import UIKit

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

class NewsPost: Object, Decodable {
    @objc dynamic var post_id: Int = 0
    @objc dynamic var type: String = ""
    @objc dynamic var date: Int = 0
    @objc dynamic var text: String = ""
    var likes: [String: Any] = [:]
    var views: [String: Int] = [:]
    var photo: Photo? = nil
    
    enum CodingKeys: String, CodingKey {
        case post_id
        case type
        case date
        case text
        case likes
        case views
        case attachments
    }
    
    enum LikeKeys: String, CodingKey {
        case count
        case user_likes
        case can_like
        case can_publish
    }
    
    enum ViewsKeys: String, CodingKey {
        case count
    }
    
    enum Attachment: String, CodingKey {
        case type
        case link
        case photo
    }
    
//    enum LinkAttachment: String, CodingKey {
//        case type
//        case link
//    }
    
    required convenience init(from decoder: Decoder) throws {
        self.init()
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.post_id = try container.decode(Int.self, forKey: .post_id)
        self.type = try container.decode(String.self, forKey: .type)
        self.text = try container.decode(String.self, forKey: .text)
        self.date = try container.decode(Int.self, forKey: .date)
        
        let likesContainer = try container.nestedContainer(keyedBy: LikeKeys.self, forKey: .likes)
        
        self.likes["count"] = try likesContainer.decode(Int.self, forKey: .count)
        self.likes["user_likes"] = try likesContainer.decode(Int.self, forKey: .user_likes)
        self.likes["can_like"] = try likesContainer.decode(Int.self, forKey: .can_like)
        self.likes["cat_publish"] = try likesContainer.decode(Int.self, forKey: .can_publish)
        
        let viewsContainer = try container.nestedContainer(keyedBy: ViewsKeys.self, forKey: .views)
        self.views["count"] = try viewsContainer.decode(Int.self, forKey: .count)
        
        do {
            var attachmentsContainer = try container.nestedUnkeyedContainer(forKey: .attachments)
            while (!attachmentsContainer.isAtEnd) {
                let attachmentContainer = try attachmentsContainer.nestedContainer(keyedBy: Attachment.self)
                let type = try attachmentContainer.decode(String.self, forKey: .type)
                if type == "photo" {
                    let photo = try attachmentContainer.decode(Photo.self, forKey: .photo)
                    self.photo = photo
                }
            }
        } catch {
            print(error)
        }
    
    }
}

class NewsPostResponse: VkListResponse, Decodable {
    var list = [NewsPost] ()
    
    required convenience init(from decoder: Decoder) throws {
        self.init()
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let responseContainer = try container.nestedContainer(keyedBy: ResponseKeys.self, forKey: .response)
        let posts = try responseContainer.decode([NewsPost].self, forKey: .items)
        list.append(contentsOf: posts)
    }
}
