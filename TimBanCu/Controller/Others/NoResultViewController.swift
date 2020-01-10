//
//  TempViewController.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 3/5/19.
//  Copyright © 2019 Duy Le 2. All rights reserved.
//

import UIKit

class NoResultViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var animatedEmoticon: AnimatedEmoticon!
    @IBOutlet weak var descriptionLabel: NoResultLabel!
    @IBOutlet weak var answerTF: UITextField!
    @IBOutlet weak var addBtn: UIButton!
    
    
    private var titleStr = "Không có kết quả"
    private var textfieldPlaceholder = "Lỗi! Không thể điền thông tin"
    private var actionStr = "Lỗi! Không thể thêm thông tin"
    
    var onAccept: (String?)->Void = {_ in}
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print()
    }
    
    func setOnAcceptBtnPressed(onAccept:@escaping (String?)->Void){
        self.onAccept = onAccept
    }
    
    func inject(titleStr:String,textfieldPlaceholder:String,actionStr:String){
        self.titleStr = titleStr
        self.textfieldPlaceholder = textfieldPlaceholder
        self.actionStr = actionStr
        viewDidLayoutSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animatedEmoticon.loopAnimation = true
        animatedEmoticon.play()
        
        descriptionLabel.text = titleStr
        
        answerTF.placeholder = textfieldPlaceholder
        
        addBtn.setTitle(actionStr, for: .normal)
        addBtn.setTitleColor(UIColor.darkGray, for: .disabled)
    }
    
    @IBAction func addBtnPressed(_ sender: Any) {
        onAccept(answerTF.text)
    }
    
    @IBAction func answerTFEditingDidEnd(_ sender: Any) {
        enableBtnBasedOnTextfield()
    }
    
    private func enableBtnBasedOnTextfield(){
        if textfieldIsEmpty(){
            addBtn.isEnabled = false
        }
        else{
            addBtn.isEnabled = true
        }
    }
    
    private func textfieldIsEmpty()->Bool{
        return answerTF.text?.trimmingCharacters(in: .whitespaces) == ""
    }


}
