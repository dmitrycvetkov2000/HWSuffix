//
//  SuffixSequence.swift
//  HWSuffix
//
//  Created by Дмитрий Цветков on 03.11.2023.
//

import Foundation

class SuffixSequence: Sequence { // Последовательность суффиксов слова
    let word: String // Слово
    var suffixes: [Suffix] = [] // Массив суффиксов
    var isSortByAsc: Bool = true // Сортировка по Asc или DESC
    
    init(word: String, isSortByAsc: Bool = true) {
        self.word = word
        self.suffixes = self.compactMap({ $0 as? Suffix })
            .sorted(by: { lefS, rightS in
                isSortByAsc ? lefS.value < rightS.value : rightS.value < lefS.value
            }) // Сортировка суффиксов слова в зависимости от isSortByAsc
        self.isSortByAsc = isSortByAsc
    }
    
    func makeIterator() -> some IteratorProtocol {
        return SuffixIterator(word: word)
    }
}
