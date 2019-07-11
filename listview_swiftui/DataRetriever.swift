//
//  DataRetriever.swift
//  listview_swiftui
//
//  Created by HeejaeKim on 11/07/2019.
//  Copyright © 2019 HeejaeKim. All rights reserved.
//

import SwiftUI
import Combine
import Foundation

class DataRetriever: BindableObject {

    let REQUEST_LIST_URL: String = "https://api.upbit.com/v1/market/all"
    let REQUEST_ITEM_URL: String = "https://api.upbit.com/v1/candles/days?market="
    let REQUEST_INTERVAL: Double = 0.2

    var names: Dictionary<String, String> = [:]
    var requestCount: Int = 0

    var didChange = PassthroughSubject<DataRetriever, Never>()
    var items: [Coin] = [] {
        didSet {
            didChange.send(self)
        }
    }

    func load() {
        request(url: REQUEST_LIST_URL, completion: onReceiveList)
    }

    func onReceiveList(data: String?) {
        if let jsonArray = toJson(str: data) {
            var delay = 0.0
            for json in jsonArray {
                let unit = json["market"] as! String
                if unit.contains("KRW") {
                    names.updateValue(json["english_name"] as! String, forKey: unit)
                    DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                        self.requestUnit(unit: unit)
                    })
                    delay += REQUEST_INTERVAL
                }
            }
        }
    }

    func requestUnit(unit: String) {
        request(url: REQUEST_ITEM_URL + unit, completion: onReceiveData)
    }

    func onReceiveData(data: String?) {
        if let jsonArray = toJson(str: data) {
            for json in jsonArray {
                createItem(json: json)
            }
        }
    }

    func createItem(json: Dictionary<String,Any>) {
        if let unit = json["market"] as? String, let name = names[unit],
            let price = (json["trade_price"] as? NSNumber)?.floatValue,
            let changeRate = (json["change_rate"] as? NSNumber)?.floatValue {
            DispatchQueue.main.async {
                let coin = Coin(id: self.requestCount, name: name, changeRate: changeRate, price: price)
                self.addItem(coin: coin)
            }
        }
    }

    func addItem(coin: Coin) {
        items.append(coin)
        requestCount += 1
    }

    func request(url: String, completion: @escaping (_: String?) -> Void) {
        var requester = URLRequest(url: URL(string: url)!)
        requester.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: requester) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                completion(nil)
                return
            }
            if let response = String(data: data, encoding: .utf8) {
                completion(response)
            } else {
                completion(nil)
            }
        }
        task.resume()
    }

    func toJson(str: String?) -> [Dictionary<String,Any>]? {
        if str == nil {
            return nil
        }

        let data = str!.data(using: .utf8)!
        do {
            if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [Dictionary<String,Any>] {
                return jsonArray
            } else {
                print("bad json: " + str!)
                return nil
            }
        } catch let error as NSError {
            print(error)
            return nil
        }
    }
}
