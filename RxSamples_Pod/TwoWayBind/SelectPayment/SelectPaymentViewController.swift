//
//  SelectPaymentViewController.swift
//  RxSamples_Pod
//
//  Created by 左得胜 on 2017/8/31.
//  Copyright © 2017年 zds. All rights reserved.
//

import UIKit

private let PaymentTableViewCellID = "PaymentTableViewCellID"

class SelectPaymentViewController: UIViewController {

    // MARK: - Property
    @IBOutlet fileprivate weak var tableView: UITableView! {
        didSet {
            tableView.rx.enableAutoDeselect().addDisposableTo(rx.disposeBag)
        }
    }
    
    fileprivate typealias PaymentSectionModel = AnimatableSectionModel<PaymentModel, PaymentEnum>
    fileprivate let dataSource = RxTableViewSectionedReloadDataSource<PaymentSectionModel> { (model, tableView, indexPath, paymentEnum) in
        let cell = tableView.dequeueReusableCell(withIdentifier: PaymentTableViewCellID, for: indexPath) as! PaymentTableViewCell
        
        cell.model = paymentEnum
        
        let selected = model[indexPath.section].model.selectedType.asObservable()
        
        selected.map { $0 == paymentEnum }
            .bind(to: cell.selectButton.rx.isSelected)
            .disposed(by: cell.rx.disposeBag)
        
        return cell
    }
    
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: - Action
    
    // MARK: - Public Method
    

}

// MARK: - Private Method
fileprivate extension SelectPaymentViewController {
    func setupUI() {
//        dataSource.configureCell = 
        let model = PaymentModel(defaultSelectedType: .aliPay)
        
        // 选中 cell 是绑定是否选中
        tableView.rx.modelSelected(PaymentEnum.self)
        .bind(to: model.selectedType)
        .disposed(by: rx.disposeBag)
        
        let paymentSection = PaymentSectionModel(model: model, items: [.aliPay, .applePay, .unionPay, .weChat])
        
        Observable.just([paymentSection])
        .bind(to: tableView.rx.items(dataSource: dataSource))
        .disposed(by: rx.disposeBag)
    }
}
