//
//  UniversityMajorViewController.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 8/2/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Lottie

class MajorViewController: UIViewController {

<<<<<<< HEAD
    var noResultLabel = NoResultLabel(type: Type.University)
=======
    var noResultLabel = NoResultLabel(text: "Không có kết quả. Bạn vui lòng điền có dấu. Bạn có muốn thêm tên khoa mới? \n Ví Dụ: Khoa Kinh Tế")
>>>>>>> UI-Design
    var noResultAddNewMajorBtn = NoResultButton(title: "Thêm Khoa Mới")
    
    var addNewMajorAlert = UIAlertController(title: "Thêm Khoa Mới", message: "", preferredStyle: .alert)
    var addNewMajorCompletedAlert = UIAlertController(title: "Trường của bạn đã được thêm!", message: "", preferredStyle: .alert)
    var majorAlreadyExistAlert = UIAlertController(title: "Trường của bạn đã có trong danh sách!", message: "Vui Lòng Chọn Trường Trong Danh Sách Chúng Tôi Hoặc Thêm trường", preferredStyle: .alert)
    
    var school:School!
    
    var majors = [MajorDetail]()
    var searchMajors = [MajorDetail]()
    
    var selectedMajor:MajorDetail!
    
    let animatedEmoticon: LOTAnimationView = {
        let animation = LOTAnimationView(name: "empty_list")
        animation.contentMode = .scaleAspectFill
        animation.loopAnimation = true
        animation.translatesAutoresizingMaskIntoConstraints = false
        return animation
    }()
    
    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAlerts()
        setUpAnimatedEmoticon()
        setupNoResultLabelAndButton()
        updateTableviewVisibilityBasedOnSearchResult()
        
    }
    
    func fetchData(){
        
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        noResultLabel.isHidden = true
//        noResultAddNewMajorBtn.isHidden = true
//        animatedEmoticon.isHidden = true
//    }
    
    @objc func addNewMajorBtnPressed(_ sender: UIButton?) {
        self.present(addNewMajorAlert, animated: true, completion: nil)
    }
    
    
    func updateTableviewVisibilityBasedOnSearchResult(){
        if(searchMajors.count == 0){
            noResultLabel.isHidden = false
            noResultAddNewMajorBtn.isHidden = false
            tableview.isHidden = true
            animatedEmoticon.isHidden = false
            animatedEmoticon.play()
        }
        else{
            noResultLabel.isHidden = true
            noResultAddNewMajorBtn.isHidden = true
            tableview.isHidden = false
            tableview.reloadData()
            animatedEmoticon.isHidden = true
            animatedEmoticon.stop()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ClassYearViewController{
            destination.majorDetail = selectedMajor
        }
    }
    
}

extension MajorViewController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchMajors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MajorTableViewCell") as! MajorTableViewCell
        cell.major = searchMajors[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedMajor = searchMajors[indexPath.row]
        performSegue(withIdentifier: "MajorToClassYearSegue", sender: self)
    }
    
    
}
