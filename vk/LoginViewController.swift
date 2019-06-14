import UIKit
import WebKit
import SwiftKeychainWrapper

class LoginViewController: UIViewController {
    
    private let SignedInSegue = "SignedIn"
    @IBOutlet weak var webview: WKWebView! {
        didSet{
            webview.navigationDelegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "oauth.vk.com"
        urlComponents.path = "/authorize"
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: "6966187"),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "scope", value: "244232191"),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "v", value: "5.68")
        ]
        
        let request = URLRequest(url: urlComponents.url!)
        
        webview.load(request)
    }
    
    // MARK: - Notification center
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

}

extension LoginViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        func successLogin(token: String) {
            // Clean DB. TBD: Add cleanup logic
            VKDao.clean()
            
            // Preload data to realm
            let client = VKAPIClient(access_token: token)
            
            client.getProfile() { user in
                VKDao.saveUserData(user)
                client.getFriends() { friends in
                    VKDao.saveFriendsData(user_id: user.id, friends: friends)
                    self.performSegue(withIdentifier: self.SignedInSegue, sender: self)
                    decisionHandler(.cancel)
                }
            }
        }
        
        let session = Session.sharedInstance
        if let token = session.token {
            successLogin(token: token)
            return
        }
        
        guard let url = navigationResponse.response.url, url.path == "/blank.html", let fragment = url.fragment  else {
            decisionHandler(.allow)
            return
        }
        
        let params = fragment
            .components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .reduce([String: String]()) { result, param in
                var dict = result
                let key = param[0]
                let value = param[1]
                dict[key] = value
                return dict
        }
        
        guard let token = params["access_token"] else {
            return
        }
        
        print("Token", token)
        session.token = token
        
        // Add access token to keychain
        KeychainWrapper.standard.set(token, forKey: ACCESS_TOKEN)
        successLogin(token: token)
    }
}
