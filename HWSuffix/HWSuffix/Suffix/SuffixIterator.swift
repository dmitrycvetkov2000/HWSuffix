//
//  SuffixIterator.swift
//  HWSuffix
//
//  Created by Дмитрий Цветков on 03.11.2023.
//

import Foundation

class SuffixIterator: IteratorProtocol {
    let word: String
    var index: Int = 0
    
    init(word: String) {
        self.word = word
    }
    
    func next() -> Suffix? {
        guard index < word.count else { return nil }
        
        let suffix = String(word.dropFirst(index)) // Получение суффиксов слова от 0 до word.count
        index += 1
        
        return Suffix(value: suffix)
    }
}
