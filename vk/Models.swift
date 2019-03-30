import Foundation
import UIKit

struct User: Equatable {
    let name: String
    let avatars: [UIImage?]
}

struct Group: Equatable {
    let name: String
    let image: UIImage?
}

struct News: Equatable {
    let text: String
    let image: UIImage?
    let views: Int
}
