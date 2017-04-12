//
//  TabBarController.swift
//  whereIsMyTrain
//
//  Created by etudiant-09 on 12/04/2017.
//  Copyright © 2017 etudiant-09. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Tabbar Controller")
        self.tabBar.barTintColor = UIColor(rgbHex: 0xFFFFFF)
        self.tabBar.tintColor = UIColor(rgbHex: 0x8FC2FF)
        self.tabBar.unselectedItemTintColor = UIColor(rgbHex: 0xCCCCCC)

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

}
