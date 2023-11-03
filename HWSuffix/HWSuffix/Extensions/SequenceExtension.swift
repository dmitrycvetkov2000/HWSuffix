//
//  SequenceExtension.swift
//  HWSuffix
//
//  Created by Дмитрий Цветков on 03.11.2023.
//

import Foundation

extension Sequence where Iterator.Element == Suffix {
    func unique() -> [Iterator.Element] {
        var values: Set<String> = []
        return filter { values.insert($0.value).inserted }
    }
}
