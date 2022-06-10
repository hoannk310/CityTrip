import UIKit
import WebKit

class WebViewController: UIViewController {
    
    @IBOutlet private weak var webView: WKWebView!
    @IBOutlet private weak var navigationContainer: UIView!
    @IBOutlet private weak var webNavigationContainer: UIView!
    
    var navigationHidden: Bool = false
    var url = URL(string: Constants.webHelpURL)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    @IBAction private func backTouched(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction private func goBackTouched(_ sender: UIButton) {
        if webView.canGoBack {
            webView.goBack()
        }
    }
    
    @IBAction private func goNextTouched(_ sender: UIButton) {
        if webView.canGoForward {
            webView.goForward()
        }
    }
    
    @IBAction private func refreshTouched(_ sender: UIButton) {
        webView.reload()
    }
    
    @IBAction private func homeTouched(_ sender: UIButton) {
        webView.load(URLRequest(url: url))
    }
    
    private func setUpView() {
        webView.uiDelegate = self
        webView.load(URLRequest(url: url))
        navigationContainer.isHidden = navigationHidden
        webNavigationContainer.isHidden = !navigationHidden
    }
    
}

extension WebViewController: WKUIDelegate {
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil {
            webView.load(navigationAction.request)
        }
        return nil
    }
}
