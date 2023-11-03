//
//  SequenceViewModel.swift
//  HWSuffix
//
//  Created by Дмитрий Цветков on 02.11.2023.
//

import SwiftUI
import Combine

class SequenceViewModel: ObservableObject {
    @Published var text: String = "" // Текст пользователя
    @Published var sequence: [SuffixSequence] = [] // Массив последовательностей суффиксов
    @Published var topSuffixes: [Suffix] = [] // Массив суффиксов которые попали в топ
    @Published var searchText = "" // Искомое слово в строке
    @Published var isTop: Bool = false // Суффикс в топе
    @Published var isSortByAsc: Bool = true // // Сортировка по Asc или DESC
    
    var cancellable = Set<AnyCancellable>()
    
    init() {
        $text
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .sink { [weak self] text in
                self?.setSequence(text: text, isSortByAsc: self?.isSortByAsc ?? true) // При изменении текста устанавливается новая последовательность
            }
            .store(in: &cancellable)
        $searchText
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .sink { [weak self] text in
                self?.selectSearchedSuffixes(text: text) // При изменении искомого слова в строке проверяем является ли суффикс исходным текстом
            }
            .store(in: &cancellable)
    }
    
    func setSequence(text: String, isSortByAsc: Bool, topCount: Int = 10) {
        sequence = text.split(separator: " ").compactMap({ word in
            SuffixSequence(word: String(word).lowercased(), isSortByAsc: isSortByAsc)
        }) // Разбиваем строку на массив строк и создаем массив последовательностей суффиксов
        setSuffixFrequency() // Установка количество повторений суффикса
        topSuffixes = getTopSuffixes(count: topCount) // Записываем топ суффикс
    }
    
    func setSuffixFrequency() -> Void {
        let grouped = sequence.flatMap { $0.suffixes }.reduce(into: [:]) { $0[$1.value, default: 0] += 1 } // Формируется словарь суффикс и количество
        
        sequence.forEach { suffixSequence in
            for suffix in suffixSequence.suffixes {
                suffix.frequency = grouped[suffix.value] ?? 0 // Записываем количество повторений у суффикса
                suffix.isSearched = suffix.value.contains(searchText.lowercased()) // Записываем в суффикс искомый ли он
            }
        }
    }
    
    func getTopSuffixes(count: Int) -> [Suffix] {
        sequence.flatMap { $0.suffixes }.filter { $0.value.count == 3 }.unique().sorted(by: { $0.frequency > $1.frequency }).prefix(count).map { $0 } // Формируем массив топ суффиксов длиной 3, уникальных
    }
    
    func selectSearchedSuffixes(text: String) {
        sequence.forEach { sequence in
            sequence.suffixes.forEach { $0.isSearched = $0.value.contains(text.lowercased()) }
        }
    }
}

