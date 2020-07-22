//
//  ReportViewSortViewController.swift
//  Flowtime
//
//  Created by Enter on 2019/6/19.
//  Copyright © 2019 Enter. All rights reserved.
//

import UIKit

class ReportViewSortViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    private var switchArray: [UISwitch] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tipLabel.lineBreakMode = .byWordWrapping
        let tipText = NSMutableAttributedString(string: "Drag and drop to reorder dashboard.\nTap the switch button to hide/show data card.")
        tipLabel.attributedText = tipText
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.isEditing = true
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentify = "dashboardCell"
        var cell: ReportTableViewCell! = tableView.dequeueReusableCell(withIdentifier: cellIdentify)  as? ReportTableViewCell
        if cell == nil {
            cell = ReportTableViewCell(style: .default, reuseIdentifier: cellIdentify)
        }
        cell?.titleLabel?.text = dashboardIndex[indexPath.row].rawValue
        cell.switchKit?.isOn =  reportShowSwitch[indexPath.row]
        cell.switchKit?.addTarget(self, action: #selector(switchAction(_:)), for: .valueChanged)
        cell.switchKit?.tag = indexPath.row
        switchArray.append(cell.switchKit!)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
      
        insertValue(&dashboardIndex, sourceIndexPath.row, destinationIndexPath.row)
        insertValue(&reportShowSwitch, sourceIndexPath.row, destinationIndexPath.row)
        insertValue(&switchArray, sourceIndexPath.row, destinationIndexPath.row)

    }
    
    @objc func switchAction(_ sender:UISwitch) {
        var index = 0
        for (i, e) in switchArray.enumerated() {
            if e.tag == sender.tag {
                index = i
                break
            }
        }
        
        reportShowSwitch[index] = sender.isOn
    }
    
    
    func insertValue<T>(_ nums: inout[T], _ a: Int, _ b: Int) {
        let value = nums[a]
        nums.remove(at: a)
        nums.insert(value, at: b)
    }
    
    private let defaultSwitch: [Bool] = Array(repeating: true, count: 6)
    private let switchKey = "SwitchKey"
    var reportShowSwitch: [Bool] {
        get {
            let reader = UserDefaults.standard.array(forKey: switchKey) as? [Bool]
            if let value = reader {
                return value
            }
            return defaultSwitch
        }
        set {
            UserDefaults.standard.set(newValue, forKey: switchKey)
        }
    }
    
    private let defaultDashboardIndex: [ReportType] = [.brainwave, .heart, .hrv, .attention, .relaxation, .pressure]
    private let dashboardIndexKey = "ReportIndex"
    var dashboardIndex: [ReportType] {
        get {
            let value = UserDefaults.standard.array(forKey: dashboardIndexKey) as? [String]
            if value != nil {
                var array: [ReportType] = []
                for e in value! {
                    if e == "Heart" {
                        array.append(.heart)
                    } else if e == "Brainwave" {
                        array.append(.brainwave)
                    } else if e == "HRV" {
                        array.append(.hrv)
                    } else if e == "Attention" {
                        array.append(.attention)
                    } else if e == "Relaxation" {
                        array.append(.relaxation)
                    } else if e == "Pressure" {
                        array.append(.pressure)
                    }
                }
                return array
            } else {
                return defaultDashboardIndex
            }
        }
        
        set {
            var array: [String] = []
            for e in newValue {
                switch e {
                case .heart:
                    array.append("Heart")
                case .brainwave:
                    array.append("Brainwave")
                case .hrv:
                    array.append("HRV")
                case .attention:
                    array.append("Attention")
                case .relaxation:
                    array.append("Relaxation")
                case .pressure:
                    array.append("Pressure")
                }
            }
            UserDefaults.standard.set(array, forKey: dashboardIndexKey)
        }
    }
    @IBAction func doneAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
