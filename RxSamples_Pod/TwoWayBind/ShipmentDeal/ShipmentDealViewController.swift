//
//  ShipmentDealViewController.swift
//  RxSamples_Pod
//
//  Created by 左得胜 on 2017/8/30.
//  Copyright © 2017年 zds. All rights reserved.
//

import UIKit

class ShipmentDealViewController: UIViewController {

    // MARK: - Property
    /// 显示商品的 tableView
    @IBOutlet fileprivate weak var tableView: UITableView! {
        didSet {
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 49, right: 0)
            tableView.scrollIndicatorInsets = tableView.contentInset
            tableView.rx.enableAutoDeselect().disposed(by: rx.disposeBag)
        }
    }
    /// 总价 label
    @IBOutlet fileprivate weak var totalPriceLabel: UILabel!
    /// 购买按钮
    @IBOutlet fileprivate weak var purchaseButton: UIButton!
    
    fileprivate typealias ProductSectionModel = AnimatableSectionModel<String, ProductInfoModel>
    fileprivate let dataSource = RxTableViewSectionedReloadDataSource<ProductSectionModel> { (_, tableView, indexPath, model) in
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductTableViewCellID", for: indexPath) as! ProductTableViewCell
        
        cell.model = model
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColor.random
        }
        
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
fileprivate extension ShipmentDealViewController {
    func setupUI() {
        
        let products = [1, 2, 3, 4, 6, 8, 10, 12]
            .map{ ProductInfoModel(id: 1000 + $0, name: "商品:\($0)", unitPrice: $0 * 100, count: Variable(0)) }
        
        let sectionInfo = Observable.just([ProductSectionModel(model: "", items: products)])
        .shareReplay(1)
        
        sectionInfo
        .bind(to: tableView.rx.items(dataSource: dataSource))
        .disposed(by: rx.disposeBag)
        
        let totalPrice = sectionInfo
            .map { $0.flatMap {$0.items} }
            .flatMap { $0.reduce(.just(0), { (result, model) in
                Observable.combineLatest(result, model.count.asObservable().map {model.unitPrice * $0}, resultSelector: +)
            }) }
        .shareReplay(1)
        
        totalPrice
            .map{ "总价：\($0)元" }
        .bind(to: totalPriceLabel.rx.text)
        .disposed(by: rx.disposeBag)
        
        totalPrice
            .map { $0 != 0 }
        .bind(to: purchaseButton.rx.isEnabled)
        .disposed(by: rx.disposeBag)
    }
}
