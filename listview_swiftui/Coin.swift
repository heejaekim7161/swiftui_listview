//
//  Coin.swift
//  listview_swiftui
//
//  Created by HeejaeKim on 11/07/2019.
//  Copyright © 2019 HeejaeKim. All rights reserved.
//

import SwiftUI
import Foundation

struct Coin: Hashable, Codable, Identifiable {
    var id: Int
    var name: String
    var changeRate: Float
    var price: Float

    func getIcon() -> Image {
        if changeRate > 0 {
            return Image(uiImage: UIImage(named: "up.png")!)
        } else if changeRate < 0 {
            return Image(uiImage: UIImage(named: "down.png")!)
        } else {
            return Image(uiImage: UIImage(named: "equal.png")!)
        }
    }

    func getTextColor() -> Color {
        if changeRate > 0 {
            return .red
        } else if changeRate < 0 {
            return .blue
        } else {
            return .black
        }
    }

    func getFormattedPrice() -> Text {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currencyAccounting
        formatter.locale = Locale(identifier: "kr_KR")

        if price >= 100.0 {
            return Text(formatter.string(from: NSNumber(value: price))!)
                    .color(getTextColor())
        } else {
            return Text("￦" + String(round(price * 10000) / 100))
                    .color(getTextColor())
        }
    }

    func getFormattedRate() -> Text {
        return Text(String(round(changeRate * 10000) / 100) + "%")
                .color(getTextColor())
    }
}
