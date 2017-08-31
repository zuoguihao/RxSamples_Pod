//
//  ProductInfoModel.swift
//  RxSamples_Pod
//
//  Created by 左得胜 on 2017/8/31.
//  Copyright © 2017年 zds. All rights reserved.
//

import Foundation

struct ProductInfoModel {
    let id: Int
    let name: String
    let unitPrice: Int
    let count: Variable<Int>
}

extension ProductInfoModel: IdentifiableType, Equatable, Hashable {
    /// The hash value.
    ///
    /// Hash values are not guaranteed to be equal across different executions of
    /// your program. Do not save hash values to use during a future execution.
    var hashValue: Int {
        return id.hashValue
    }

    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    static func ==(lhs: ProductInfoModel, rhs: ProductInfoModel) -> Bool {
        return lhs.id == rhs.id
    }

    var identity: Int {
        return id
    }
    
}
