import UIKit
import SwiftKeychainWrapper

class NewsController: UIViewController {
    @IBOutlet weak var newsTableView: UITableView!
    
    var news = [NewsPost] ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        newsTableView.dataSource = self
        newsTableView.register(UINib(nibName: "NewsViewCell", bundle: Bundle.main), forCellReuseIdentifier: "NewsViewCell")
        newsTableView.rowHeight = UITableView.automaticDimension
        newsTableView.estimatedRowHeight = 600
        
        let token = KeychainWrapper.standard.string(forKey: ACCESS_TOKEN)
        DispatchQueue.global().async {
            let client = VKAPIClient(access_token: token!)
            client.getNewsPosts() {posts in
                DispatchQueue.main.async {
                    self.news = posts
                    self.newsTableView.reloadData()
                }
            }
        }
    }
}

extension NewsController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsViewCell", for: indexPath) as! NewsViewCell
        let item = news[indexPath.row]
        cell.newsLabel?.text = item.text
        
//        if let image = item.image {
//            if image.size.height == image.size.width {
//                cell.newsImage?.image = image
//            } else {
//                let minLength = min(image.size.height, image.size.width)
//                let boundingBox = CGRect(x: minLength/2, y: minLength/2, width: minLength, height: minLength)
//                cell.newsImage?.image = image.cropped(boundingBox: boundingBox)
//            }
//        }
        
        if let photo_uri = item.photo?.uri {
                cell.newsImage.downloaded(from: photo_uri)
        }
        cell.newsLikeControl.likes = item.likes["count"] as! Int
        cell.newsViews?.text = String.init(item.views["count"] as! Int)
        return cell
    }
}

extension UIImage {
    func cropped(boundingBox: CGRect) -> UIImage? {
        guard let cgImage = self.cgImage?.cropping(to: boundingBox) else {
            return nil
        }
        
        return UIImage(cgImage: cgImage)
    }
}
