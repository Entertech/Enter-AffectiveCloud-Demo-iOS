//
//  ChooseTagViewController.swift
//  EnterAffectiveCloudDemo
//
//  Created by Enter on 2019/12/10.
//  Copyright © 2019 Enter. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import EnterAffectiveCloud

class ChooseTagViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    

    @IBOutlet weak var mainTitle: UILabel!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    var selectTag: [Int]?
    var tagCount = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    lazy var flow:UICollectionViewFlowLayout = {
        
        let f = UICollectionViewFlowLayout.init()
        f.minimumInteritemSpacing = 20
        f.minimumLineSpacing = 20
        f.estimatedItemSize = CGSize(width: 80, height: 30)
        f.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        f.headerReferenceSize = CGSize(width: 100, height: 60)
        
        return f
    }()
    
    func setUI() {
        
        submitBtn.layer.cornerRadius = 22
        submitBtn.isEnabled = false
        
        deleteBtn.layer.cornerRadius = 22
        
        let collection = UICollectionView(frame: CGRect.zero, collectionViewLayout: flow)
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = .white
        collection.allowsSelection = true
        collection.register(BtnCollectionViewCell.self, forCellWithReuseIdentifier: "BtnCollectionViewCell")
        collection.register(UICollectionReusableView.classForCoder(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "UICollectionReusableView")
        self.view.addSubview(collection)
        
        collection.snp.makeConstraints {
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
            $0.top.equalTo(mainTitle).offset(36)
            $0.bottom.equalTo(submitBtn.snp.top).offset(-40)
        }

    }
    
    @objc
    func tagChoosedPressed(_ sender: UIButton) {
        
    }

    @IBAction func submitPressed(_ sender: Any) {
        if let _ = TimeRecord.chooseDim {
            var dimArray: [DimModel] = []
            if let models = ACTagModel.shared.tagModels {
                let currentTag = ACTagModel.shared.currentCase
                if let tags = models[currentTag].tag {
                    for e in 0..<tagCount {
                        if let dims = tags[e].dim, let selectTag = selectTag {
                            dimArray.append(dims[selectTag[e]])
                        }
                    }
                }
            }
            TimeRecord.chooseDim?.append(dimArray)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func deletePressed(_ sender: Any) {
        let ok = UIAlertAction(title: "确定", style: .default) { (action) in
            if let _ = TimeRecord.time {
                TimeRecord.time?.removeLast()
                TimeRecord.time?.removeLast()
                self.navigationController?.popViewController(animated: true)
            }
        }
        let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let alert = UIAlertController(title: "删除记录", message: nil, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(ok)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if let models = ACTagModel.shared.tagModels {
            let currentTag = ACTagModel.shared.currentCase
            if let tags = models[currentTag].tag {
                tagCount = tags.count
                selectTag = Array(repeating: 9999, count: tagCount)
                print("section: \(tags.count)")
                return tags.count
            }
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let models = ACTagModel.shared.tagModels {
            let currentTag = ACTagModel.shared.currentCase
            if let tags = models[currentTag].tag {
                
                if let dims = tags[section].dim {
                    print("section item: \(section) dim: \(dims.count)")
                    return dims.count
                }
            }
        }
        return 0


    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView .dequeueReusableCell(withReuseIdentifier: "BtnCollectionViewCell", for: indexPath) as! BtnCollectionViewCell
        
        if let models = ACTagModel.shared.tagModels {
            let currentTag = ACTagModel.shared.currentCase
            if let tags = models[currentTag].tag {
                if let dim = tags[indexPath.section].dim {
                    print("section: \(indexPath.section) row: \(indexPath.row)")
                    cell.setModel(dim: dim[indexPath.row])
                }
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let reusableview = UICollectionReusableView()
        if kind == UICollectionView.elementKindSectionHeader {
            let headView:UICollectionReusableView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "UICollectionReusableView", for: indexPath)
            headView.backgroundColor = .white
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
            if let models = ACTagModel.shared.tagModels {
                let currentTag = ACTagModel.shared.currentCase
                if let tags = models[currentTag].tag {
                    label.text = tags[indexPath.section].name_cn
                }
            }
            headView.addSubview(label)
            label.snp.makeConstraints {
                $0.centerY.equalToSuperview().multipliedBy(1.4)
                $0.left.equalToSuperview().offset(8)
            }
            return headView
        }
        return reusableview
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let models = ACTagModel.shared.tagModels {
            let currentTag = ACTagModel.shared.currentCase
            if let tags = models[currentTag].tag {
                if let dim = tags[indexPath.section].dim {
                    for (i, _) in dim.enumerated() {
                        if i != indexPath.row {
                            let myPath: IndexPath = IndexPath(row: i, section: indexPath.section)
                            let cell = collectionView.cellForItem(at: myPath) as! BtnCollectionViewCell
                            cell.setNormal()
                        } else {
                            selectTag![indexPath.section] = indexPath.row
                            var isChoosed = true
                            for e in selectTag! {
                                if e == 9999 {
                                    isChoosed = false
                                    break
                                }
                            }
                            if isChoosed {
                                submitBtn.isEnabled = true
                                submitBtn.backgroundColor = UIColor.hexStringToUIColor(hex: "4B5DCC")
                                
                            } else {
                                submitBtn.isEnabled = false
                                submitBtn.backgroundColor = .lightGray
                            }
                            let cell = collectionView.cellForItem(at: indexPath) as! BtnCollectionViewCell
                            cell.setSelect()
                        }
                    }
                }
            }
        }
        
        
  
    }
    
    
}


