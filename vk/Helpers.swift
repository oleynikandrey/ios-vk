import Foundation
import UIKit

extension UIImageView {
    
    private func getCacheDirectory() -> URL {
        return FileManager.default.urls(for: FileManager.SearchPathDirectory.cachesDirectory, in: .userDomainMask)[0]
    }
    
    private func getImageCacheFileName(from url: URL) -> String {
        return "\(url.hashValue).png"
    }
    
    private func getImage(by url: URL) -> UIImage? {
        let fileUrl = getCacheDirectory().appendingPathComponent(getImageCacheFileName(from: url))
        let imageData = try? Data(contentsOf: fileUrl)

        if let data = imageData {
            return UIImage(data: data)
        } else {
            return nil
        }
    }
    
    private func saveImage(by url: URL, image: UIImage) {
        let fileUrl = getCacheDirectory().appendingPathComponent(getImageCacheFileName(from: url))
        guard let data = image.pngData() else {
            return
        }
        try? data.write(to: fileUrl)
    }
    
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        if let image = getImage(by: url) {
            self.image = image
        } else {
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard
                    let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                    let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                    let data = data, error == nil,
                    let image = UIImage(data: data)
                    else { return }
                DispatchQueue.main.async() {
                    self.image = image
                    self.saveImage(by: url, image: image)
                }
                }.resume()
        }
    }
    
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
