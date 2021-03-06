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

func blur(image: UIImage) -> UIImage {
    let inputCIImage = CIImage(image: image)!
    
    let blurFilter = CIFilter(name: "CIGaussianBlur", parameters: [kCIInputImageKey: inputCIImage])!
    let outputImage = blurFilter.outputImage!
    let context = CIContext()
    let cgiImage = context.createCGImage(outputImage, from: outputImage.extent)
    
    let bluredImage = UIImage(cgImage: cgiImage!)
    return bluredImage
}

class AsyncOperation: Operation {
    enum State: String {
        case ready, executing, finished
        fileprivate var keyPath: String {
            return "is" + rawValue.capitalized
        }
    }
    
    var state = State.ready {
        willSet {
            willChangeValue(forKey: state.keyPath)
            willChangeValue(forKey: newValue.keyPath)
        }
        didSet {
            didChangeValue(forKey: state.keyPath)
            didChangeValue(forKey: oldValue.keyPath)
        }
    }
    
    override var isAsynchronous: Bool {
        return true
    }
    
    override var isReady: Bool {
        return super.isReady && state == .ready
    }
    
    override var isExecuting: Bool {
        return state == .executing
    }
    override var isFinished: Bool {
        return state == .finished
    }
    override func start() {
        if isCancelled {
            state = .finished
        } else {
            main()
            state = .executing
        }
    }
    override func cancel() {
        super.cancel()
        state = .finished
    }
}

class GetImageOperation: AsyncOperation {
    private var imageUri: String
    var image: UIImage?
    
    init(image_uri: String) {
        self.imageUri = image_uri
    }
    
    override func main() {
        URLSession.shared.dataTask(with: URL(string: imageUri)!) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data) else { return }
            
            self.image = image
            self.state = .finished
            
            }.resume()
    }
}

class SetImageOperation: Operation {
    var imageView: UIImageView
    
    init(imageView: UIImageView) {
        self.imageView = imageView
    }
    
    override func main() {
        guard let op = dependencies.first as? GetImageOperation else { return }
        imageView.image = op.image
    }
}
