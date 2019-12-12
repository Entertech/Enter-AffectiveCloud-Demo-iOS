//
//  TagListViewController.swift
//  EnterAffectiveCloudDemo
//
//  Created by Enter on 2019/12/9.
//  Copyright © 2019 Enter. All rights reserved.
//

import UIKit
import EnterAffectiveCloud

class TagListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let tableView = UITableView(frame: CGRect.zero, style: .grouped)
    var index = 0
    init(id: Int) {
        super.init(nibName: nil, bundle: nil)
        index = id
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "数据标签"
        self.navigationController?.navigationItem.largeTitleDisplayMode = .never    
        tableView.dataSource = self
        tableView.delegate = self
        setUI()
    }
    
    func setUI() {
        self.view.backgroundColor = .white
        
        tableView.backgroundColor = .white
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints  {
            $0.top.equalTo(self.view.safeAreaLayoutGuide)
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let models = ACTagModel.shared.tagModels {
            if let tags = models[index].tag {
                return tags.count
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let models = ACTagModel.shared.tagModels {
            if let tags = models[index].tag {
                return tags[section].dim?.count ?? 0
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rIndex = indexPath.row
        let section = indexPath.section
        let identifier = "com.enter.experiment.identifier.r\(rIndex).s\(indexPath.section)"
        let cell: UITableViewCell
        
        if let reuseView = tableView.dequeueReusableCell(withIdentifier: identifier) {
            cell = reuseView
        } else {
            cell = UITableViewCell(style: .default, reuseIdentifier: identifier)
        }
        cell.accessoryType = .none
        if let models = ACTagModel.shared.tagModels {
            if let tags = models[self.index].tag {
                if let dim = tags[section].dim?[rIndex] {
                    cell.textLabel?.text = dim.name_cn
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let models = ACTagModel.shared.tagModels {
            if let tags = models[index].tag {
                return tags[section].name_cn
            }
        }
        return ""
    }

}
