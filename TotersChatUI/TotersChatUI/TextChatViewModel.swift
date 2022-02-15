//
//  TextChatViewModel.swift
//  TotersChatUI
//
//  Created by Husam Dayya on 14/02/2022.
//

import Foundation

struct TextChatViewModel {
    let text: String
    let isSent: Bool
}

extension TextChatViewModel {
    static var testData: [TextChatViewModel] {
        [
            TextChatViewModel(text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.", isSent: true),
            TextChatViewModel(text: "Nullam ornare, massa sit amet pulvinar pulvinar, tortor ante iaculis dui, nec consequat lorem urna luctus elit. Suspendisse ipsum lectus, blandit ac ultrices quis, ultricies non ligula. Morbi sit amet vehicula nisl.", isSent: true),
            TextChatViewModel(text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam ornare, massa sit amet pulvinar pulvinar, tortor ante iaculis dui, nec consequat lorem urna luctus elit. Suspendisse ipsum lectus, blandit ac ultrices quis, ultricies non ligula. Morbi sit amet vehicula nisl. Maecenas in lacus dapibus, lobortis erat a, interdum ante. Morbi fermentum viverra tellus sit amet volutpat.", isSent: false),
            TextChatViewModel(text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.", isSent: false)
        ]
    }
}
