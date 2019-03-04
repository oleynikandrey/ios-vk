import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var loginInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    
    private let SignedInSegue = "SignedIn"
    
    private let defaultLogin = "admin"
    private let defaultPassword = "password"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let hideKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        scrollView.addGestureRecognizer(hideKeyboardGesture)
    }
    
    // MARK: - Notification center
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWasShown),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillBeHidden(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - Keyboard actions
    
    @objc func keyboardWasShown(notification: Notification) {
        let info = notification.userInfo! as NSDictionary
        let kbSize = (info.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: kbSize.height, right: 0.0)
        
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc func keyboardWillBeHidden(notification: Notification) {
        // Устанавливаем отступ внизу UIScrollView, равный 0
        let contentInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc func hideKeyboard() {
        scrollView.endEditing(true)
    }
    
    // MARK: - Sign in
    
    @IBAction func signInButtonPressed(_ sender: Any) {
        guard let login = loginInput.text, !login.isEmpty,
            let password = passwordInput.text, !password.isEmpty
        else {
            print("Empty login or password")
            return
        }
        
        if login == defaultLogin && password == defaultPassword {
            performSegue(withIdentifier: SignedInSegue, sender: self)
        } else {
            showErrorMessage()
        }
    }
    
    func showErrorMessage() {
        let alert = UIAlertController(
            title: "Login Error",
            message: "Incorrect login or password",
            preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(
            title: "OK",
            style: UIAlertAction.Style.cancel,
            handler: nil)
        alert.addAction(okButton)
        present(alert, animated: true)
    }
    
    //MARK: - Unwind
    
    @IBAction func logout(for unwindSegue: UIStoryboardSegue) {
        loginInput.text?.removeAll()
        passwordInput.text?.removeAll()
    }
}
