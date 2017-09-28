//
//  ViewController.swift
//  queen-ios
//
//  Created by user on 27/9/2017.
//  Copyright © 2017 saulgor. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

class LanguageHelper {
    static let sharedInstance = LanguageHelper()
    
    // These are the properties you can store in your singleton
    func StringforKey(key:String)->String{
        let lan:String = UserDefaults.standard.object(forKey: "language") as! String
        let string:String?
        if lan.hasPrefix("zh"){
            let path = Bundle.main.path(forResource: "zh-Hant", ofType: "lproj")
            let bundle = Bundle(path: path!)
            string = bundle?.localizedString(forKey: key, value: nil, table: nil)
        }else{
            let path = Bundle.main.path(forResource: "en", ofType: "lproj")
            let bundle = Bundle(path: path!)
            string = bundle?.localizedString(forKey: key, value: nil, table: nil)
        }
        
        return string!
    }
}

