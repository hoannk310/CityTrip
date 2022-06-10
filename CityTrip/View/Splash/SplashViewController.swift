import UIKit
import Alamofire

class SplashViewController: UIViewController {
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        remoteConfig = RemoteConfig.remoteConfig()
//        let settings = RemoteConfigSettings()
//        settings.minimumFetchInterval = 10
//        remoteConfig.configSettings = settings
//        remoteConfig.setDefaults(["appName": false as NSObject])
//        remoteConfig.setDefaults(["url": "" as NSObject])
//        remoteConfig.fetch(withExpirationDuration: 0) { status, error in
//            if status == .success, error == nil {
//                self.remoteConfig.activate { [self] _, erro in
//                    //                    print("test ", self.remoteConfig.configValue(forKey: "appName").boolValue)
//                    //                    print("test ", self.remoteConfig.configValue(forKey: "url").stringValue)
//                    if self.remoteConfig.configValue(forKey: "appName").boolValue {
//                        showWebView(url: remoteConfig.configValue(forKey: "url").stringValue ?? "")
//                        return
//                    }
//                    self.showMain()
//                }
//            }
//        }
////        if remoteConfig!.configValue(forKey: "appName").boolValue {
////            showWebView(url: remoteConfig!.configValue(forKey: "url").stringValue ?? "")
////            return
////        }
       showMain()
    }
    
    private func showMain() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            UserDefaults.standard.set(true, forKey: "shouldShowWebView")
            let chatVC = TabbarControllerViewController(nibName: "TabbarControllerViewController", bundle: nil)
            self.navigationController?.pushViewController(chatVC, animated: true)
        }
    }
    
    private func showWebView(url: String) {
                DispatchQueue.main.async {
        let webVC = WebViewController(nibName: "WebViewController", bundle: nil)
        webVC.navigationHidden = true
        webVC.url = URL(string: url)!
        self.navigationController?.pushViewController(webVC, animated: true)
                }
    }
}
