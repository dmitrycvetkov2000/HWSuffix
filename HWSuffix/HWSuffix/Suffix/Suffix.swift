//
//  Suffix.swift
//  HWSuffix
//
//  Created by Дмитрий Цветков on 03.11.2023.
//

import Foundation

class Suffix: Hashable, Identifiable {
    var id = UUID().uuidString
    var value: String // Суффикс слова
    var frequency: Int = 0 // количество повторений в строке
    var isSearched: Bool = false // Если суффикс в поиске
    
    init(value: String) {
        self.value = value
    }
    
    static func == (lhs: Suffix, rhs: Suffix) -> Bool {
        lhs.value == rhs.value
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(value)
    }
}
