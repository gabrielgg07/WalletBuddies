//
//  PlaidFunc.swift
//  WalletBuddies
//
//  Created by Gabriel Gonzalez on 9/23/25.
//

import Foundation
import LinkKit

// MARK: - Networking helpers

func fetchLinkToken(completion: @escaping (String?) -> Void) {
    guard let url = URL(string: "http://127.0.0.1:5000/api/create_link_token") else {
        completion(nil)
        return
    }

    var request = URLRequest(url: url)
    request.httpMethod = "POST"

    URLSession.shared.dataTask(with: request) { data, _, error in
        guard let data = data, error == nil else {
            print("❌ fetch error:", error?.localizedDescription ?? "unknown")
            completion(nil)
            return
        }

        if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
           let token = json["link_token"] as? String {
            DispatchQueue.main.async {
                print("✅ Got link_token:", token)
                completion(token)
            }
        } else {
            print("❌ bad response:", String(data: data, encoding: .utf8) ?? "")
            completion(nil)
        }
    }.resume()
}

func exchangePublicToken(_ publicToken: String, completion: @escaping (Bool) -> Void) {
    guard let url = URL(string: "http://127.0.0.1:5000/api/exchange_public_token") else {
        completion(false)
        return
    }

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = try? JSONSerialization.data(withJSONObject: ["public_token": publicToken])

    URLSession.shared.dataTask(with: request) { data, _, error in
        guard let data = data, error == nil else {
            print("❌ exchange error:", error?.localizedDescription ?? "unknown")
            completion(false)
            return
        }

        print("ℹ️ exchange response:", String(data: data, encoding: .utf8) ?? "")
        completion(true)
    }.resume()
}
