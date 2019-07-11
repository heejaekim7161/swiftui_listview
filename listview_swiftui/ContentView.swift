//
//  ContentView.swift
//  listview_swiftui
//
//  Created by HeejaeKim on 11/07/2019.
//  Copyright © 2019 HeejaeKim. All rights reserved.
//

import SwiftUI

struct ContentView : View {
    @EnvironmentObject var retriever: DataRetriever

    var body: some View {
        VStack {
            Image(uiImage: UIImage(named: "upbit.jpg")!)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 75, alignment: .center)
                .clipped()
            List(retriever.items) { item in
                Row(coin: item)
            }
        }
    }
}

struct Row: View {
    var coin: Coin

    var body: some View {
        HStack(alignment: .top) {
            coin.getIcon()
                .resizable()
                .frame(width: 25.0, height: 25.0, alignment: .leading)
            Text(coin.name)
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            coin.getFormattedRate()
                .font(.subheadline)
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .trailing)
            coin.getFormattedPrice()
                .font(.subheadline)
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .trailing)
        }
        .aspectRatio(contentMode: .fill)
    }
}
