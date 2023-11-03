//
//  ContentView.swift
//  HWSuffix
//
//  Created by Дмитрий Цветков on 02.11.2023.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel: SequenceViewModel = SequenceViewModel()
    
    var body: some View {
        VStack {
            Text("Введите текст: ")
            TextEditor(text: $viewModel.text)
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.black, lineWidth: 1.5)
                }
            HStack {
                Text("Тип сортировки: ")
                Picker("", selection: $viewModel.isSortByAsc) {
                    Text("ASC")
                        .tag(true)
                    Text("DESC")
                        .tag(false)
                }
                .pickerStyle(.segmented)
                .onChange(of: viewModel.isSortByAsc) { newValue in
                    viewModel.setSequence(text: viewModel.text, isSortByAsc: newValue)
                }
            }
            
            Text("Суффиксы: ")
            TextField("Суффикс", text: $viewModel.searchText)
            
            Group {
                Picker("", selection: $viewModel.isTop) {
                    Text("All")
                        .tag(false)
                    Text("Top")
                        .tag(true)
                }
                .pickerStyle(.segmented)
                
                if viewModel.isTop {
                    ScrollView {
                        ForEach(viewModel.topSuffixes, id: \.self) { suffix in
                            HStack {
                                Text(suffix.value)
                                    .foregroundColor(suffix.isSearched ? .red : .black)
                                Spacer()
                                Text("Повторения \(suffix.frequency)")
                            }
                        }
                    }
                } else {
                    ForEach(viewModel.sequence, id: \.word) { element in
                        VStack {
                            Text(element.word)
                            
                            ForEach(element.suffixes, id: \.self) { suffix in
                                HStack {
                                    Text(suffix.value)
                                        .foregroundColor(suffix.isSearched ? .red : .black)
                                    Spacer()
                                    Text("Повторения \(suffix.frequency)")
                                }
                            }
                        }
                    }
                }
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
