//
//  LaunchScreenViewController.swift
//  whereIsMyTrain
//
//  Created by etudiant-09 on 11/04/2017.
//  Copyright © 2017 etudiant-09. All rights reserved.
//

import UIKit

class LaunchScreenViewController: UIViewController {

    var hue : CGFloat = 0
    var saturation : CGFloat = 0
    var brightness : CGFloat = 0
    var alpha : CGFloat = 0
    
    var timer : Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor?.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        /*
        if (self.view.backgroundColor?.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha))! {
            print(hue)
            print(brightness)
            print(saturation)
            print(alpha)
 
        } */
//        self.timer = Timer(timeInterval: 0.1, target: self, selector: #selector(LaunchScreenViewController.lighterBackground), userInfo: nil, repeats: true)
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: lighterBackground(with: ))
//        self.timer.fire()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func lighterBackground(with timer : Timer) {
        self.saturation = self.saturation - 0.1
        self.view.backgroundColor = UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
//        print("yo \(self.hue)")
        if self.saturation < 0 {
            self.timer.invalidate()
            self.performSegue(withIdentifier: "LaunchToTabBar", sender: self)
        }
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        
//        NavitiaHelper.getNavitiaRegions() {
//             json in
//            if let json = json {
//            print (json)
//            }
//        
//        }
//     
////        let networkManager = NetworkManager.sharedInstance
////        
////        networkManager.getInfo(endPoint: "https://api.navitia.io/v1/", extensionEndPoint: "coverage/fr-idf/lines", parameters: [:], user: "ead72df8-7e1a-4ecf-a325-3e779f5326fd", password: "" ) {
////            (json, error) in
////            guard error	== nil else {
////                print("error lors de la récuppération des Informations JCDecaux")
////                return
////            }
////            if let json = json {
////                print(json)
////            }
////            
////        }
//     }
 
    
    
}
