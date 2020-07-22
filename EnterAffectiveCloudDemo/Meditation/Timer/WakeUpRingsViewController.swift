//
//  WakeUpRingsViewController.swift
//  Flowtime
//
//  Created by Enter on 2020/6/12.
//  Copyright © 2020 Enter. All rights reserved.
//

import UIKit

class WakeUpRingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    private var player: LocalPlayer?
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    let rows = ["无", "钟声","木鱼", "风铃", "钵"]
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell_identifier = "com.cell.identifier"
        let cell: UITableViewCell
        if let reuseCell = tableView.dequeueReusableCell(withIdentifier: cell_identifier) {
            cell = reuseCell
        } else {
            cell = UITableViewCell(style: .value1, reuseIdentifier: cell_identifier)
        }
        cell.textLabel?.text = rows[indexPath.row]
        if let sound = Preference.meditationSound {
            if rows[indexPath.row] == sound {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
        } else {
            if indexPath.row == 0 {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let soundName = rows[indexPath.row]
        if indexPath.row == 0 {
            self.player?.stop()
            Preference.meditationSound = nil
        } else {
            
            Preference.meditationSound = soundName
            let path = Bundle.main.path(forResource: soundName, ofType: "mp3")
            let url = URL(fileURLWithPath: path!)
            if let play = LocalPlayer(url) {
                self.player = play
                self.player?.play()
            }
            
        }
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }

    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
