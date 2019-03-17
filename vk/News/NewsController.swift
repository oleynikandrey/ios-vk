import UIKit

class NewsController: UIViewController {
    @IBOutlet weak var newsTableView: UITableView!
    
    var news = [News] ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        newsTableView.dataSource = self
        newsTableView.register(UINib(nibName: "NewsViewCell", bundle: Bundle.main), forCellReuseIdentifier: "NewsViewCell")
        newsTableView.rowHeight = UITableView.automaticDimension
        newsTableView.estimatedRowHeight = 600
        
        news = [
            News(text: news1, image: #imageLiteral(resourceName: "news1"), views: 10),
            News(text: news2, image: #imageLiteral(resourceName: "news2"), views: 100),
            News(text: news3, image: #imageLiteral(resourceName: "news3"), views: 1000),
        ]
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
        
        if let image = item.image {
            if image.size.height == image.size.width {
                cell.newsImage?.image = image
            } else {
                let minLength = min(image.size.height, image.size.width)
                let boundingBox = CGRect(x: minLength/2, y: minLength/2, width: minLength, height: minLength)
                cell.newsImage?.image = image.cropped(boundingBox: boundingBox)
            }
        }
        
        cell.newsViews?.text = String.init(item.views)
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
