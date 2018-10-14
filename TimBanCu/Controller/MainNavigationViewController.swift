//
//  testnaviViewController.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 10/14/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import UIKit

class MainNavigationViewController: UINavigationController, UINavigationBarDelegate {

    private var stopAddingClassConfirmAlert:ConfirmationAlert?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    func navigationBar(_ navigationBar: UINavigationBar, shouldPop item: UINavigationItem) -> Bool {
        
        if let vc = viewControllers [(self.viewControllers.count)-1] as? ClassNameViewController{
            
            if(stopAddingClassConfirmAlert == nil){
                stopAddingClassConfirmAlert = ConfirmationAlert(title: "Bạn Có Muốn Huỷ Thêm Lớp?", message: "Lớp sẽ không được lưu vào hệ thống của chúng tôi") {
                    DispatchQueue.main.async {
                        self.viewDidLayoutSubviews()
                        self.popViewController(animated: true)
                        
                    }
                }
            }
            
            switch(vc.state){
            case .AddingClass:
                stopAddingClassConfirmAlert?.showAlert(viewcontroller: vc)
                return false
            case .NotAddingClass:
                self.viewDidLayoutSubviews()
                popViewController(animated: true)
                return true
            }
        }
        else{
            self.viewDidLayoutSubviews()
            popViewController(animated: true)
            return true
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
