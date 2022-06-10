//
//  AppUtil.swift
//  SearchRepositories+Mvvm
//
//  Created by Apple on 2/23/21.
//

import UIKit
import UserNotifications

final class AppUtil: NSObject {
    
    class var appDelegate: AppDelegate? {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        return appDelegate
    }
    
    class func convertJsonString<T>(_ response: ResponseObject?, toType: T.Type) throws -> T? where T: Decodable {
        guard let jsonData  = response?.jsonString?.data(using: .utf8) else {
           return nil
        }
        let decoder = JSONDecoder()
        do {
          let orderDetailResponse = try decoder.decode(toType, from: jsonData)
            return orderDetailResponse
        } catch {
            debugPrint(error.localizedDescription)
        }
        return nil
    }
    class func showAlert (text: String, vc: UIViewController) {
        let alert = UIAlertController(title: "Error !!", message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        alert.view.tintColor = .red
        vc.present(alert, animated: true)
    }
    
    class func createNotification (title: String, body: String, time: Double, identifier: String) {
//        let center = UNUserNotificationCenter.current()
//        let content = UNMutableNotificationContent()
//        content.title = title
//        content.body = body
//        content.sound = .default
//
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: time, repeats: false)
//
//        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
//
//        center.add(request) { (error) in
//            if error != nil {
//                print(error)
//            }
//        }
    }
}
