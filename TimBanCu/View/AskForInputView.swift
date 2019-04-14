//
//  AskForInputView.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 2/18/19.
//  Copyright © 2019 Duy Le 2. All rights reserved.
//

import Foundation
import UIKit

class AskForInputView:UIView{
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var animatedEmoticon: AnimatedEmoticon!
    
    @IBOutlet weak var descriptionLabel: NoResultLabel!
    
    @IBOutlet weak var answerTF: UITextField!
    
    
    private let onAccept:(_ input:String)->Void
    private let type:NoResultType
    
    
    init(frame: CGRect, type:NoResultType, onAccept:@escaping (_ input:String)->Void) {
        self.onAccept = onAccept
        self.type = type
        super.init(frame: frame)
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        animatedEmoticon.loopAnimation = true
        animatedEmoticon.play()
        
        titleLabel.text = "Không có kết quả"
        
        switch(type){
        case .Institution:
            descriptionLabel.text = "Bạn có muốn thêm trường mới?\nBạn vui lòng điền có dấu."
            break
        case .Major:
            descriptionLabel.text = "Bạn có muốn thêm khoa mới? Ví Dụ: Khoa Kinh Tế\nBạn vui lòng điền có dấu."
            break
        case .Class:
            descriptionLabel.text = "Bạn có muốn thêm lớp mới?\n Ví dụ: 10A11\nBạn vui lòng điền có dấu."
            break
        case .Student:
            descriptionLabel.text = "Bạn có muốn thông tin của mình?\nBạn vui lòng điền có dấu."
        }
    }

    private func setup(){
        let contentView = Bundle.main.loadNibNamed("AskForInputView", owner: self, options: nil)?[0] as! UIView
    
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
    }

    required init?(coder aDecoder: NSCoder) {
        self.onAccept = { name in }
        self.type = .Class
        super.init(coder: aDecoder)
        setup()
    }
}
