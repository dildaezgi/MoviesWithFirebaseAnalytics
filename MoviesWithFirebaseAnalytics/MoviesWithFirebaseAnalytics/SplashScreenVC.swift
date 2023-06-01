//
//  SplashScreenVC.swift
//  MoviesWithFirebaseAnalytics
//
//  Created by Dilda Ezgi Metincan Personal on 2.06.2023.
//

import UIKit
import Firebase
import AFNetworking

class SplashScreenVC: UIViewController {
    let reachabilityManager = AFNetworkReachabilityManager.shared()
    let remoteConfig = RemoteConfig.remoteConfig()
    var label: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
        label.center = CGPoint(x: 160, y: 285)
        label.textAlignment = .center
        view.addSubview(label)

        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings

        remoteConfig.setDefaults(["splash_text" : "Hoş geldiniz!" as NSObject])

        fetchRemoteConfig()
        
        reachabilityManager.setReachabilityStatusChange { status in
           switch status {
           case .notReachable:
               DispatchQueue.main.async {
                   let alertController = UIAlertController(title: "Hata", message: "İnternet bağlantısı yok", preferredStyle: .alert)
                   alertController.addAction(UIAlertAction(title: "Tamam", style: .default))
                   self.present(alertController, animated: true, completion: nil)
               }
           case .reachableViaWiFi, .reachableViaWWAN:
               print("Connection OK!")
           default:
               print("Unknown network status")
           }
       }
       reachabilityManager.startMonitoring()
        
        Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { timer in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "ViewController")
            viewController.modalTransitionStyle = .crossDissolve
            viewController.modalPresentationStyle = .fullScreen
            self.present(viewController, animated: true, completion: nil)
        }
    }

    func fetchRemoteConfig() {
        remoteConfig.fetch(withExpirationDuration: TimeInterval(60)) { [weak self] (status, error) -> Void in
            if status == .success {
                print("Config fetched!")
                self?.remoteConfig.activate(completion: nil)
                let splashText = self?.remoteConfig.configValue(forKey: "splash_text").stringValue ?? "Welcome :)"
                DispatchQueue.main.async {
                    self?.label.text = splashText
                }
            } else {
                print("Config not fetched")
                print("Error: \(error?.localizedDescription ?? "No error available.")")
            }
        }
    }
}

