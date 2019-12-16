//
//  ThirdViewController.swift
//  EnterAffectiveCloudDemo
//
//  Created by Enter on 2019/11/17.
//  Copyright © 2019 Enter. All rights reserved.
//

import UIKit
import SafariServices

class ThirdViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "设置"
        
        self.view.backgroundColor = #colorLiteral(red: 0.9568627451, green: 0.9607843137, blue: 0.9764705882, alpha: 1)
        tableView.backgroundColor = #colorLiteral(red: 0.9568627451, green: 0.9607843137, blue: 0.9764705882, alpha: 1)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationItem.largeTitleDisplayMode = .always
        addHeaderView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        versionLabel.text = Preference.appVersion
    }
    
    let sectionList = ["", ""]
    let cellIconList = [[#imageLiteral(resourceName: "hardware version")],[#imageLiteral(resourceName: "Stockholm-help")]]
    let cellTitlelist = [["实验选择"],["帮助中心"]]
    
    func numberOfSections(in tableView: UITableView) -> Int {
        sectionList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellTitlelist[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "com.enter.me.identifier.r\(indexPath.row).s\(indexPath.section)"
        let secIndex = indexPath.section
        let rowIndex = indexPath.row
        let cell: UITableViewCell
        
        if let reuseView = tableView.dequeueReusableCell(withIdentifier: identifier) {
            cell = reuseView
        } else {
            cell = UITableViewCell(style: .value1, reuseIdentifier: identifier)
        }
        cell.accessoryType = .disclosureIndicator
        cell.imageView?.image = cellIconList[secIndex][rowIndex]
        cell.textLabel?.text = cellTitlelist[secIndex][rowIndex]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            
            let vc = ExperimentSettingViewController()
            vc.modalPresentationStyle = .fullScreen
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        case (1, 01):
            presentSafari(Preference.help)

        default:
            presentSafari(Preference.help)
        }
    }

    private func addHeaderView() {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 30))
        view.backgroundColor = UIColor.clear
        tableView.tableHeaderView = view
    }
    
    /// Safari 显示网页
    private func presentSafari(_ defaultKey: String) {
        if let url = URL(string: defaultKey) {
            let sf = SFSafariViewController(url: url)
            present(sf, animated: true, completion: nil)
        }
    }

}
