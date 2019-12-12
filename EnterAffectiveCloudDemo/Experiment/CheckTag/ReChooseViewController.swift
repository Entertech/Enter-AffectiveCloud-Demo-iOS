//
//  ReChooseViewController.swift
//  EnterAffectiveCloudDemo
//
//  Created by Enter on 2019/12/10.
//  Copyright © 2019 Enter. All rights reserved.
//

import UIKit

class ReChooseViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {

    let tableView = UITableView()
    var picker = UIPickerView()
    var index = 0
    var bgView: UIView?
    var selectRow = 0
    var titleNavi = ""
    var isReport = false
    var strArray: [String] = []
    init(index: Int, title: String) {
        super.init(nibName: nil, bundle: nil)
        self.index = index
        self.titleNavi = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(tableView)
        self.view.backgroundColor = .white
        tableView.snp.makeConstraints {
            $0.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
        tableView.delegate = self
        tableView.dataSource = self
        let foot = UIView()
        tableView.tableFooterView = foot
        navigationItem.title = self.titleNavi
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !isReport {
            
            if let dims = TimeRecord.chooseDim {
                return  dims[index].count
            }
        } else {
            return strArray.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let identifier = "com.enter.check.identifier.r\(index).s\(indexPath.section)"
        let cell: UITableViewCell
        
        if let reuseView = tableView.dequeueReusableCell(withIdentifier: identifier) {
            cell = reuseView
        } else {
            cell = UITableViewCell(style: .value1, reuseIdentifier: identifier)
        }
        cell.accessoryType = .none
        if !isReport {
            if let dims = TimeRecord.chooseDim {
                cell.textLabel?.text = dims[index][row].name_cn
            }
            
        } else {
            cell.textLabel?.text = strArray[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !isReport {
            tableView.deselectRow(at: indexPath, animated: true)
            selectRow = indexPath.row
            setTimerPickerView()
        }

    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if !isReport {
            
            return "点击对应选项可以修改标签"
        }
        return ""
    }

    // MARK: - picker
    private func setTimerPickerView() {
        if let bgView = self.bgView {
            bgView.isHidden = false
            picker.reloadAllComponents()
        } else {
            bgView = UIView()
            // 黑色背景
            bgView?.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
            self.view.addSubview(bgView!)
            bgView?.snp.makeConstraints{
                $0.left.right.top.bottom.equalToSuperview()
            }
            
            // 时间选择器
            picker.delegate = self
            picker.dataSource = self
            picker.backgroundColor = .white
            bgView?.addSubview(picker)
            picker.snp.makeConstraints{
                $0.left.right.bottom.equalToSuperview()
                $0.height.equalTo(210)
            }
            
            // 菜单栏
            let menu = UIView()
            bgView?.addSubview(menu)
            menu.backgroundColor = .white
            menu.snp.makeConstraints{
                $0.left.right.equalToSuperview()
                $0.bottom.equalTo(picker.snp.top)
                $0.height.equalTo(44)
            }
            
            let cancelBtn = UIButton()
            cancelBtn.setTitle("取消", for: .normal)
            cancelBtn.setTitleColor(.systemBlue, for: .normal)
            cancelBtn.addTarget(self, action: #selector(cancelTouchupInside), for: .touchUpInside)
            menu.addSubview(cancelBtn)
            cancelBtn.snp.makeConstraints {
                $0.left.equalToSuperview().offset(16)
                $0.centerY.equalToSuperview()
            }
            
            let okBtn = UIButton()
            okBtn.setTitle("完成", for: .normal)
            okBtn.setTitleColor(.systemBlue, for: .normal)
            okBtn.addTarget(self, action: #selector(okTouchupInside), for: .touchUpInside)
            menu.addSubview(okBtn)
            okBtn.snp.makeConstraints {
                $0.right.equalToSuperview().offset(-16)
                $0.centerY.equalToSuperview()
            }

        }
        
    }
    
    @objc
    private func cancelTouchupInside() {
        self.bgView?.isHidden = true
    }
    
    @objc
    private func okTouchupInside() {
        
        if let models = ACTagModel.shared.tagModels {
            let currentTag = ACTagModel.shared.currentTag
            if let tags = models[currentTag].tag {
                if let dim = tags[selectRow].dim {
                    TimeRecord.chooseDim![index][selectRow] = dim[picker.selectedRow(inComponent: 0)]
                    tableView.cellForRow(at: IndexPath(row: selectRow, section: 0))?.textLabel?.text = dim[picker.selectedRow(inComponent: 0)].name_cn
                }
            }
        }
        self.bgView?.isHidden = true
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if let models = ACTagModel.shared.tagModels {
            let currentTag = ACTagModel.shared.currentTag
            if let tags = models[currentTag].tag {
                if let dim = tags[selectRow].dim {
                    return dim.count
                }
            }
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if let models = ACTagModel.shared.tagModels {
            let currentTag = ACTagModel.shared.currentTag
            if let tags = models[currentTag].tag {
                if let dim = tags[selectRow].dim {
                    return dim[row].name_cn
                }
            }
        }
        return nil
    }
    

}
