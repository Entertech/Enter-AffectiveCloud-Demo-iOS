//
//  ChooseTimerViewController.swift
//  Flowtime
//
//  Created by Enter on 2020/6/11.
//  Copyright © 2020 Enter. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ChooseTimerViewController: UIViewController {

    @IBOutlet weak var timerCustom: TimerCustomView!
    @IBOutlet weak var timer10: TimerSelectView!
    @IBOutlet weak var timer15: TimerSelectView!
    @IBOutlet weak var timer20: TimerSelectView!
    @IBOutlet weak var timer25: TimerSelectView!
    @IBOutlet weak var timer30: TimerSelectView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var startBtn: UIButton!
    
    private var pickerView: PickerView?
    private let disposeBag = DisposeBag()
    private var selectTime = Preference.noMusicMeditationDuration.toTime()
    private var lastTime: (hour: Int, mins: Int, seconds: Int)?
    private let hourUnit = ["hours"]
    private let hourItems = [Int](0...23)
    private let minsUnit = ["mins"]
    private let minsItems = [Int](0...59)
    
    private var timerViewList: [TimerSelectView] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        timerViewList.append(timer10)
        timerViewList.append(timer15)
        timerViewList.append(timer20)
        timerViewList.append(timer25)
        timerViewList.append(timer30)
        initUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    private func initUI() {
        tableView.delegate = self
        tableView.dataSource = self
        startBtn.setTitleColor(Colors.white, for: .normal)
        startBtn.setTitleColor(.systemGray, for: .highlighted)
        startBtn.backgroundColor = UIColor.colorWithHexString(hexColor: "#4B5DCC")
        startBtn.cornerRadius = 22.5
        let currentTimer = Int(Preference.noMusicMeditationDuration) / 60
        updateSelect(value: currentTimer)
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    //MARK:- Action

    @IBAction func select10Action(_ sender: Any) {
        updateSelect(value: 10)
        Preference.noMusicMeditationDuration = Double(10 * 60)
    }
    
    @IBAction func select15Action(_ sender: Any) {
        updateSelect(value: 15)
        Preference.noMusicMeditationDuration = Double(15 * 60)
    }
    
    @IBAction func select20Action(_ sender: Any) {
        updateSelect(value: 20)
        Preference.noMusicMeditationDuration = Double(20 * 60)
    }
    
    @IBAction func select25Action(_ sender: Any) {
        updateSelect(value: 25)
        Preference.noMusicMeditationDuration = Double(25 * 60)
    }
    
    @IBAction func select30Action(_ sender: Any) {
        updateSelect(value: 30)
        Preference.noMusicMeditationDuration = Double(30 * 60)
    }
    
    @IBAction func popAction(_ sender: Any) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    @IBAction func customAction(_ sender: Any) {
        selectTime = Preference.noMusicMeditationDuration.toTime()
        if pickerView == nil {
            pickerView = PickerView()
            pickerView?.pickerView.dataSource = self
            pickerView?.pickerView.delegate = self
            pickerView?.titleLabel.text = "自定义时间"
            lastTime = selectTime
            pickerView?.okButton.rx.tap.bind { [weak self] in
                guard let self = self else {return}
                if let last = self.lastTime {
                    self.selectTime = last
                    let nTime = last.hour * 3600 + last.mins * 60
                    Preference.noMusicMeditationDuration = Double(nTime)
                    self.updateSelect(value: nTime / 60)
                }
                
                self.pickerView?.dismiss {
                    self.pickerView?.removeFromSuperview()
                }
               
            }.disposed(by: disposeBag)
            
            pickerView?.cancelButton.rx.tap.bind { [weak self] in
                guard let self = self else {return}
                self.pickerView?.dismiss {
                    self.pickerView?.removeFromSuperview()
                }
            }.disposed(by: disposeBag)

        }
        self.view.addSubview(pickerView!)
        let hours = selectTime.hour
        let mins = selectTime.mins
        pickerView?.pickerView.selectRow(hours, inComponent: 0, animated: true)
        pickerView?.pickerView.selectRow(mins, inComponent: 2, animated: true)
        pickerView?.snp.makeConstraints {
            $0.edges.equalTo(0)
        }
        pickerView?.poper()
    }
    
    @IBAction func startBtnAction(_ sender: Any) {
        let controller = MeditationViewController()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    private func updateSelect(value: Int) {
        deSelect()
        if value == 10 {
            timer10.selectTimer(isSelected: true)
        } else if value == 15 {
            timer15.selectTimer(isSelected: true)
        } else if value == 20 {
            timer20.selectTimer(isSelected: true)
        } else if value == 25 {
            timer25.selectTimer(isSelected: true)
        } else if value == 30 {
            timer30.selectTimer(isSelected: true)
        }
        timerCustom.selectTimer(mins: value)
    }
    
    private func deSelect() {
        for i in 0..<timerViewList.count {
            if timerViewList[i].bIsSelected {
                timerViewList[i].selectTimer(isSelected: false)
            }
        }
        if timerCustom.bIsSelected {
            timerCustom.selectTimer(mins: 10)
        }
       
    }
}

extension ChooseTimerViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell_identifier = "com.cell.sound"
        let cell: UITableViewCell
        if let reuseCell = tableView.dequeueReusableCell(withIdentifier: cell_identifier) {
            cell = reuseCell
        } else {
            cell = UITableViewCell(style: .value1, reuseIdentifier: cell_identifier)
        }
        let soundName = Preference.meditationSound ?? "钟声"
        cell.textLabel?.text = "结束提示音"
        cell.detailTextLabel?.text = soundName
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if section == 0 {
            return "计时器结束后，我们会播放结束音以提醒您。"
        }
        return ""
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            let vc = WakeUpRingsViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    
}

extension ChooseTimerViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 4
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return 24
        } else if component == 1 {
            return 1
        } else if component == 2 {
            return 60
        } else if component == 3 {
            return 1
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return "\(hourItems[row])"
            case 1:
            return "\(hourUnit[row])"
            case 2:
            return "\(minsItems[row])"
            case 3:
            return "\(minsUnit[row])"
        default:
            break
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 70
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if 0 == component {
            lastTime?.hour = row
            if row == 0 {
                pickerView.reloadComponent(2)
            }
        }

        if 2 == component {
            lastTime?.mins = row
        }
        if let last = lastTime {
            if last.hour == 0 && last.mins < 3 {
                self.pickerView?.okButton.isEnabled = false
            } else {
                self.pickerView?.okButton.isEnabled = true
            }
        }
    }
}
