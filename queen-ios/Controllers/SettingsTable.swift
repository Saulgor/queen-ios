//
//  SettingsViewController.swift
//  TuaskAI
//
//  Created by chenze on 2016/10/30.
//  Copyright © 2016年 share. All rights reserved.
//

import Foundation

class SettingsTable: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        
        followInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        followInit()
    }
    
    func followInit(){
        self.dataSource = self
        self.delegate = self
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 70
        case 1:
            return 70
        case 2:
            return 70
        case 3:
            return 90
        case 4:
            return 90
        default:
            return 44
        }

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsSwitchCell", for: indexPath as IndexPath) as!SettingsSwitchCell
            cell.switchTitle.text = "Cheat mode"
            cell.switchDetail.text = "This option allow you skip all the steps and show the results right away."
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsSwitchCell", for: indexPath as IndexPath) as!SettingsSwitchCell
            cell.switchTitle.text = "News and updates"
            cell.switchDetail.text = "Receive all the important news and updates we think worth your notice."
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsSwitchCell", for: indexPath as IndexPath as IndexPath) as!SettingsSwitchCell
            cell.switchTitle.text = "Clear all history"
            cell.switchDetail.text = "Look for a fresh start?  This will clear up all your past historial conversations."
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsTitleDetailCell", for: indexPath as IndexPath) as!SettingsTitleDetailCell
            cell.title.text = "Need Help?"
            cell.detail.text = "You can check our frequently asked questions (FAQs) for all the informations."
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsTitleDetailCell", for: indexPath as IndexPath) as!SettingsTitleDetailCell
            cell.title.text = "Your Favorite"
            cell.detail.text = "Your saved message are stored here."
            return cell
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsDetailCell", for: indexPath as IndexPath) as!SettingsDetailCell
            cell.detail.text = "Please rate us in the App store"
            return cell
        case 6:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsDetailCell", for: indexPath as IndexPath) as!SettingsDetailCell
            cell.detail.text = "Read our privacy policy"
            return cell
        case 7:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsDetailCell", for: indexPath as IndexPath) as!SettingsDetailCell
            cell.detail.text = "Read our terms and conditions"
            return cell
        case 8:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsDetailCell", for: indexPath as IndexPath) as!SettingsDetailCell
            cell.detail.text = "Send us feedback or report a bug"
            return cell
        default:
            return UITableViewCell()
        }
    }
}

class SettingsSwitchCell: UITableViewCell {
    @IBOutlet weak var switchTitle: UILabel!
    @IBOutlet weak var switchDetail: UILabel!
    @IBOutlet weak var modeToggle: UISwitch!
    
    
}

class SettingsTitleDetailCell: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var detail: UILabel!
    
}

class SettingsDetailCell: UITableViewCell {
    @IBOutlet weak var detail: UILabel!
    
}
