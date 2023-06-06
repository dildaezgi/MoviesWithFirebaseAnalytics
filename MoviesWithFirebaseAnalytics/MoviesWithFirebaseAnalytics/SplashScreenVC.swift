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
    var label2: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
        label.font = .boldSystemFont(ofSize: 35)
        label.center = self.view.center
        label.textAlignment = .center
        view.addSubview(label)
        
        label.transform = CGAffineTransform(translationX: -self.view.bounds.width, y: 0)
        
        label2 = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
        label2.font = .boldSystemFont(ofSize: 35)
        label2.center = self.view.center
        label2.textAlignment = .center
        view.addSubview(label2)
        
        label2.transform = CGAffineTransform(translationX: self.view.bounds.width, y: 0)
        
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
            let storyboard = UIStoryboard(name: "MoviesViewController", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "MoviesViewController")
            viewController.modalTransitionStyle = .crossDissolve
            viewController.modalPresentationStyle = .fullScreen
            self.present(viewController, animated: true, completion: nil)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.77, delay: 1, options: .curveEaseOut, animations: {
            self.label.transform = .identity
            self.label2.transform = .identity
        }, completion: { _ in
            self.pulseAnimation(label: self.label)
            self.pulseAnimation(label: self.label2)
        })
    }
    
    func fetchRemoteConfig() {
        remoteConfig.fetch(withExpirationDuration: TimeInterval(60)) { [weak self] (status, error) -> Void in
            if status == .success {
                print("Config fetched!")
                self?.remoteConfig.activate(completion: nil)
                let splashText = self?.remoteConfig.configValue(forKey: "splash_text").stringValue ?? "Welcome :)"
                DispatchQueue.main.async {
                    self?.label.text = splashText
                    self?.label2.text = splashText
                }
            } else {
                print("Config not fetched")
                print("Error: \(error?.localizedDescription ?? "No error available.")")
            }
        }
    }
    
    func pulseAnimation(label: UILabel) {
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       options: [.repeat, .autoreverse],
                       animations: {
            label.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }, completion: nil)
    }
}

