//
//  StatisticsViewController.swift
//  FlowtimeUI
//
//  Created by Anonymous on 2019/4/2.
//  Copyright © 2019 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import UIKit
import RxSwift
import Moya
import Networking
import SVProgressHUD
import RxCocoa

class StatisticsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var isFinishWithOnlyAudio = false // 音频（无设备）体验
    
    var chooseIndex = 0
    private let disposeBag = DisposeBag()
    var headColor: UIColor = .white
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setup()
        self.layout()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.loadData()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.view.backgroundColor = Colors.bg1

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let list = SyncManager.shared.loadLocalMeditationList(Preference.userID) {
            if !SyncManager.shared.checkDownloadFile(list: list) {
                SVProgressHUD.show()
                SVProgressHUD.dismiss(withDelay: 6)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        _tableview.isHidden = false
    }

    private let _navigationView = UIView()

    private let titleLabel = UILabel()
    private let guideView = GuideView()
    private let deleteBtn = UIButton(type: .system)
    private let backBtn = UIButton()
    private let isControlHidden = BehaviorRelay<Bool>(value: false)
    private let okBtn = UIButton(type: .system)
    private var tableviewOffset = 52
    private func setup() {
        self._navigationView.addSubview(deleteBtn)
        self._navigationView.addSubview(okBtn)
        self._navigationView.addSubview(titleLabel)
        self._navigationView.addSubview(backBtn)
        self.titleLabel.text = "旅程"
        self.titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        let isHiddenDriver = self.isControlHidden.asDriver()
        isHiddenDriver.drive(onNext: { (flag) in
            self.backBtn.isHidden = !flag
        }, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        isHiddenDriver.drive(self.okBtn.rx.isHidden).disposed(by: disposeBag)
        self.backBtn.setImage(#imageLiteral(resourceName: "icon_back_color"), for: .normal)
        self.backBtn.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        self.deleteBtn.setTitle("编辑", for: .normal)
        self.deleteBtn.setTitleColor(Colors.btn1, for: .normal)
        self.okBtn.setTitle("删除", for: .normal)
        self.deleteBtn.titleLabel?.textAlignment = .right
        self.okBtn.titleLabel?.textAlignment = .left
        self.okBtn.setTitleColor(UIColor.colorWithHexString(hexColor: "#FF6682"), for: .normal)
        self.okBtn.setTitleColor(Colors.btnDisable, for: .disabled)
        self.okBtn.isEnabled = false
        isControlHidden.accept(true)
        
        deleteBtn.addTarget(self, action: #selector(editBtnPressed(sender:)), for: .touchUpInside)
        okBtn.addTarget(self, action: #selector(okBtnPressed(sender:)), for: .touchUpInside)
        
        self.view.backgroundColor = .white
        if !Preference.statistics {
            guideView.cornerRadius = 8
            guideView.message = "你能够在这里找到所有的训练数据，点击卡片查看数据。"
            guideView.isUserInteractionEnabled = true
            guideView.closeButton.rx.tap.bind { [weak self] in
                guard let self = self else {return}
                self.guideView.removeFromSuperview()
                self._tableview.tableHeaderView = nil
                Preference.statistics = true
            }.disposed(by: disposeBag)
            let tableviewHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 104))
            tableviewHeaderView.addSubview(guideView)
            guideView.snp.makeConstraints {
                $0.left.equalTo(16)
                $0.right.equalTo(-16)
                $0.bottom.equalTo(0)
                $0.height.greaterThanOrEqualTo(92)
            }
            _tableview.tableHeaderView = tableviewHeaderView
        }

        //_navigationView.addSubview(_segment)
        _navigationView.backgroundColor = Colors.bg1

        _tableview.backgroundColor = .clear
        _tableview.dataSource = self
        _tableview.delegate = self
        _tableview.separatorStyle = .none
        _tableview.allowsMultipleSelectionDuringEditing = true
        _tableview.contentInset = UIEdgeInsets(top: CGFloat(tableviewOffset), left: 0, bottom: 0, right: 0)
        _tableview.setContentOffset(CGPoint(x: 0, y: -tableviewOffset), animated: false)
        setupListView()
        
    }

    private func layout() {
        self.deleteBtn.snp.makeConstraints {
            $0.right.equalTo(-10)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(44)
            $0.width.equalTo(60)
        }
        
        okBtn.snp.makeConstraints {
            $0.left.equalTo(10)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(44)
            $0.width.equalTo(60)
        }
        
        backBtn.snp.makeConstraints {
            $0.left.equalTo(16)
            $0.centerY.equalToSuperview()
            $0.height.width.equalTo(44)
        }
        
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }


        _navigationView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide)
    
            $0.left.right.equalToSuperview()
            $0.height.equalTo(44)
        }
    }

    let cellColors: [UIColor] = [Colors.green5, Colors.blue5, Colors.yellow5, Colors.red5]
    let cellLiteralColor: [UIColor] = [Colors.green2, Colors.blue2, Colors.yellow2, Colors.red2]
    let cellBgImages: [[UIImage]] = [[#imageLiteral(resourceName: "img_statistics_green2"), #imageLiteral(resourceName: "img_statistics_green1"), #imageLiteral(resourceName: "img_statistics_green3")],
                                     [#imageLiteral(resourceName: "img_statistics_blue3"), #imageLiteral(resourceName: "img_statistics_blue2"), #imageLiteral(resourceName: "img_statistics_blue1")],
                                     [#imageLiteral(resourceName: "img_statistics_yellow1"), #imageLiteral(resourceName: "img_statistics_yellow3"), #imageLiteral(resourceName: "img_statistics_yellow2")],
                                     [#imageLiteral(resourceName: "img_statistics_red1"), #imageLiteral(resourceName: "img_statistics_red2"), #imageLiteral(resourceName: "img_statistics_red3")]]
    private let _tableview = UITableView()
    private func setupListView() {

        self.view.addSubview(_tableview)
        self.view.addSubview(_navigationView)

        
        _tableview.snp.makeConstraints {
            $0.top.equalTo(self._navigationView.snp.bottom).offset(-44)
            $0.right.left.bottom.equalTo(0)
        }
    }

    private var recordList = [Record]()
    private var isSample = false
    private func loadData() {
        if let result = RecordRepository.query(Preference.userID), result.count > 0 {
            self.deleteBtn.isHidden = false
            self.recordList.removeAll()
            let re = result.map { $0.mapperToRecord() }

            self.recordList = re.sorted(by: { (a, b) in
                return a.startTime! >= b.startTime!
            })
            self._tableview.reloadData()
            isSample = false
        } else {
            self.deleteBtn.isHidden = true
            let sampleRecord = Record(id: 0,
                                userID: 0,
                                startTime: Date(),
                                endTime: Date(timeIntervalSinceNow: 8*60),
                                lessonID: 0,
                                lessonName: "Break at work",
                                courseID: 0,
                                courseName: "Balance",
                                meditationID: -1,
                                courseImage: "")
            self.recordList = [sampleRecord]
            isSample = true
            self._tableview.reloadData()
        }
    }

    @objc
    private func segmentValueChange(_ segmentCtrl: UISegmentedControl) {
        
        switch segmentCtrl.selectedSegmentIndex {
        case 0:
            self._tableview.isHidden = false
            self._navigationView.backgroundColor = headColor
        case 1:
            self._tableview.isHidden = true
            self._navigationView.backgroundColor = .white
            
        default:
            break
        }
    }
    
    @objc
    private func backAction() {
        self.navigationController?.popViewController(animated: true)
    }

    //MARK: table view method
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.recordList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "record_reuse_id"
        let cell: RecordViewCell
        if let reuseView = tableView.dequeueReusableCell(withIdentifier: identifier) as? RecordViewCell {
            cell = reuseView
        } else {
            cell = RecordViewCell(reuseIdentifier: identifier)
        }
        let record = self.recordList[indexPath.row]
        cell.cellColor = .random()
        cell.backgroundColor = .clear
        cell.timeLabel.text = record.startTime!.string(custom: "HH:mm M.d.yyyy")
        let duration = record.duration / 60 < 1 ? 1 : record.duration / 60
        cell.lessonLabel.text = "\(duration)分钟"
        //cell.courseLabel.text = record.lessonName!
        let colorIndex = indexPath.row % cellColors.count
        cell.cellColor = cellColors[colorIndex]
        cell.literalColor = cellLiteralColor[colorIndex]
        cell.imageview.image = cellBgImages[colorIndex].randomElement()
        cell.isMeditationRecord = (record.meditationID != 0)
        if isSample { //示例数据
            cell.isSample = true
        }
        cell.selectedBackgroundView = UIView()
        cell.selectedBackgroundView?.backgroundColor = Colors.bg2
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 142
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if !tableView.isEditing {
            return .none
        } else {
            return .delete
        }
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !tableView.isEditing {
            let vc = Statistics2ViewController()
            vc.isExample = self.isSample
            vc.listIndex = indexPath.row
            vc.navigationView.snp.updateConstraints {
                $0.height.equalTo(88)
            }
            vc.navigationView.isHidden = true
            vc.isHiddenNavigationBar = false
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            if let rows = tableView.indexPathsForSelectedRows {
                if rows.count > 0 {
                    okBtn.isEnabled = true
                } else {
                    okBtn.isEnabled = false
                }
            } else {
                okBtn.isEnabled = false
            }

        }

    }
    

    
    @objc func editBtnPressed(sender: UIButton) {
        if _tableview.isEditing {
            isControlHidden.accept(true)
            okBtn.isEnabled = false
            sender.setTitle("编辑", for: .normal)
            _tableview.setEditing(false, animated: true)
        } else{
            isControlHidden.accept(false)
            sender.setTitle("取消", for: .normal)
            _tableview.setEditing(true, animated: true)
        }

    }
    
    @objc func okBtnPressed(sender:UIButton) {
        guard let selectRows = _tableview.indexPathsForSelectedRows else { return  }
        SVProgressHUD.show()
        var selectCount = 0
        let totalCount = selectRows.count
        var deleteArray: [Int] = []
        
        let userLesson = UserLessonRequest()
        selectRows.forEach({ (indexPath) in
            
            let selected = self.recordList[indexPath.row]
            deleteArray.append(selected.id!)
            userLesson.userLessonDelete(selected.id!).subscribe(onNext: { (response) in
                
            }, onError: { (error) in
                if let err = error as? MoyaError {
                    if let response = err.response?.data {
                        //DLog(String(data: response, encoding: .utf8) as Any)
                    }
                    if let request = err.response?.request?.httpBody {
                        //DLog(String(data: request, encoding: .utf8) as Any)
                    }
                }
                selectCount += 1
                
            }, onCompleted: {
                selectCount += 1
            } , onDisposed: nil).disposed(by: disposeBag)
            
        })

        DispatchQueue.global().async {
            while (selectCount < totalCount) {
                Thread.sleep(until: Date()+1)
            }
            selectCount = 0
            do  {
                try deleteArray.forEach { (value) in
                    try RecordRepository.delete(value, finish: { (flag) in
                        selectCount += 1
                    })
                }
                
            } catch {
                return
            }
            
            while (selectCount < totalCount) {
                Thread.sleep(until: Date()+0.1)
            }
            
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
                self.isControlHidden.accept(false)
                self.okBtn.isEnabled = false
                self.okBtn.isHidden = true
                self.backBtn.isHidden = false
                self.deleteBtn.setTitle("编辑", for: .normal)
                self.loadData()
                self.navigationItem.leftBarButtonItem = nil
                self._tableview.setEditing(false, animated: true)
            }
        }


    }
}
