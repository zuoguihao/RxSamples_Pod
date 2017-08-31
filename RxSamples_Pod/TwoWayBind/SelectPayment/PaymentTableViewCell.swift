//
//  PaymentTableViewCell.swift
//  RxSamples_Pod
//
//  Created by 左得胜 on 2017/8/31.
//  Copyright © 2017年 zds. All rights reserved.
//

import UIKit

class PaymentTableViewCell: UITableViewCell {

    // MARK: - Property
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var selectButton: UIButton!
    
    var model: PaymentEnum = .aliPay {
        didSet {
            iconImageView.image = model.icon
            nameLabel.text = model.name
        }
    }
    
    // MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

/*
extension Reactive where Base: PaymentTableViewCell {
    var isSelected: UIBindingObserver<UIButton, Bool> {
        return base.selectButton.rx.isSelected
    }
}
*/
