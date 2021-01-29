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

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = lang("设置")
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.view.backgroundColor = #colorLiteral(red: 0.9568627451, green: 0.9607843137, blue: 0.9764705882, alpha: 1)
        tableView.backgroundColor = #colorLiteral(red: 0.9568627451, green: 0.9607843137, blue: 0.9764705882, alpha: 1)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addHeaderView()
        addFooterCopyRightView()
    }
    
    let sectionList = [""]
    let cellIconList = [[#imageLiteral(resourceName: "Stockholm-help"), #imageLiteral(resourceName: "Stockholm-Terms of Services"), #imageLiteral(resourceName: "Stockholm-Privacy")]]
    let cellTitlelist = [[lang("帮助中心"), lang("使用条款"), lang("隐私政策")]]
    
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
            presentSafari(Preference.help)
        case (0, 1):
            presentSafari(Preference.terms)
        case (0, 2):
            presentSafari(Preference.privacy)
        default:
            presentSafari(Preference.help)
        }
    }

    private func addHeaderView() {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 30))
        view.backgroundColor = UIColor.clear
        tableView.tableHeaderView = view
    }
    
    private func addFooterCopyRightView() {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 72))
        let versionLabel = UILabel()
        versionLabel.text = Preference.appVersion
        versionLabel.textColor = #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        versionLabel.font = UIFont.systemFont(ofSize: 11)
        versionLabel.textAlignment = .center
//        let copyrightLabel = UILabel()
//        copyrightLabel.text = App.copyright
//        copyrightLabel.textColor = #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
//        copyrightLabel.font = UIFont.systemFont(ofSize: 11)
//        copyrightLabel.textAlignment = .center
        view.addSubview(versionLabel)
//        view.addSubview(copyrightLabel)
        self.tableView.tableFooterView = view
        versionLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-12)
            $0.centerX.equalToSuperview()
        }
    }
    
    /// Safari 显示网页
    private func presentSafari(_ defaultKey: String) {
        if let url = URL(string: defaultKey) {
            let sf = SFSafariViewController(url: url)
            present(sf, animated: true, completion: nil)
        }
    }

}
