//
//  ExperimentSettingViewController.swift
//  EnterAffectiveCloudDemo
//
//  Created by Enter on 2019/12/9.
//  Copyright © 2019 Enter. All rights reserved.
//

import UIKit
import SnapKit

class ExperimentSettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let tableView = UITableView(frame: CGRect.zero, style: .grouped)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationItem.largeTitleDisplayMode = .never
        self.navigationItem.title = "实验选择"
        setUI()
    }
    
    func setUI()  {
        self.view.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        self.view.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ACTagModel.shared.tagModels?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        let identifier = "com.enter.experiment.identifier.r\(index).s\(indexPath.section)"
        let cell: UITableViewCell
        
        if let reuseView = tableView.dequeueReusableCell(withIdentifier: identifier) {
            cell = reuseView
        } else {
            cell = UITableViewCell(style: .value1, reuseIdentifier: identifier)
        }
        cell.accessoryType = .detailButton
        if let models = ACTagModel.shared.tagModels {
            if index == ACTagModel.shared.currentCase {
                cell.imageView?.image = #imageLiteral(resourceName: "choose")
            }
            
            cell.textLabel?.text = models[index].name_cn
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ACTagModel.shared.currentCase = indexPath.row
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let tagListVC = TagListViewController(id: indexPath.row)
        tagListVC.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(tagListVC, animated: true)
    }

    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return "检查信息是否正确，如果不正确请联系后台管理员进行修改。"
    }

}
