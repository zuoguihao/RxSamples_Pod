//
//  ProductTableViewCell.swift
//  RxSamples_Pod
//
//  Created by 左得胜 on 2017/8/30.
//  Copyright © 2017年 zds. All rights reserved.
//

import UIKit

class ProductTableViewCell: UITableViewCell {

    // MARK: - Property
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var unitPriceLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var minusBtn: UIButton!
    @IBOutlet weak var plusBtn: UIButton!
    
    var model: ProductInfoModel? {
        didSet {
            guard let model = model else { return }
            
            nameLabel.text = model.name
            unitPriceLabel.text = "单价：\(model.unitPrice)元"
            
            (rx_count <-> model.count).disposed(by: rx.disposeBag)
        }
    }
    
    private var count: Int = 0 {
        didSet {
            if count < 0 {
                fatalError("count 不能小于0")
            }
            
            minusBtn.isEnabled = count != 0
            plusBtn.isEnabled = count <= 9
            countLabel.text = String(count)
        }
    }
    
    /// cell 数据变动和 model 数据变动互相绑定
    var rx_count: ControlProperty<Int> {
        let source = Observable<Int>.create { [weak self] (observer) in
            self?.countChangedClosure = observer.onNext
            return Disposables.create()
        }
        .distinctUntilChanged()
        
        let sink = UIBindingObserver(UIElement: self) { (cell, count) in
            cell.count = count
        }
        .asObserver()
        
        return ControlProperty(values: source, valueSink: sink)
    }
    
    /// 数据改变闭包
    private var countChangedClosure: ((Int) -> Void)?
    
    // MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - Private Method
    private typealias MyAction = (_ lhs: inout Int, _ rhs: Int) -> Void
    private func changeCount(_ action: MyAction) {
        action(&count, 1)
        countChangedClosure?(count)
    }
    
    // MARK: - Action
    @IBAction func minusBtnClick() {
        changeCount(-=)
    }
    
    @IBAction func plusBtnClick() {
        changeCount(+=)
    }
    

}
