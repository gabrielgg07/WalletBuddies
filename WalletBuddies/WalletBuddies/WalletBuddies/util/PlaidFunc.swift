//
//  PlaidFunc.swift
//  WalletBuddies
//
//  Created by Gabriel Gonzalez on 9/23/25.
//

import Foundation
import LinkKit

//
//  Config.swift
//  WalletBuddies
//

import Foundation

#if targetEnvironment(simulator)
let BaseURL = "http://127.0.0.1:5001"
#else
let BaseURL = "https://a133df227dc2.ngrok-free.app"  // your Mac’s LAN IP for iPhone testing
#endif

// MARK: - Networking helpers

func fetchLinkToken(completion: @escaping (String?) -> Void) {
    guard let url = URL(string:  "\(BaseURL)/api/plaid/create_link_token") else {
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

func exchangePublicToken(
    _ publicToken: String,
    auth: AuthManager,
    completion: @escaping (Bool) -> Void
) {
    guard let url = URL(string: "\(BaseURL)/api/plaid/exchange_public_token") else {
        completion(false)
        return
    }

    let body: [String: Any] = [
        "public_token": publicToken,
        "email": auth.email // 👈 comes from the injected AuthManager
    ]

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = try? JSONSerialization.data(withJSONObject: body)

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


//
//  PlaidService.swift
//  WalletBuddies
//



struct Transaction: Identifiable, Decodable {
    let id: Int
    let name: String?
    let amount: Double
    let date: String?
    let merchant_name: String?
    let category: [String]?
    let pending: Bool?
}



func refreshTransactions(
    auth: AuthManager,
    completion: @escaping ([Transaction]) -> Void
) {
    guard let email = auth.email.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
        completion([])
        return
    }

    // 1️⃣ FIRE SYNC to update DB
    guard let syncURL = URL(string: "\(BaseURL)/api/plaid/transactions/sync?email=\(email)") else {
        completion([])
        return
    }

    URLSession.shared.dataTask(with: syncURL) { _, _, _ in

        // 2️⃣ AFTER SYNC COMPLETES, FETCH ALL STORED TRANSACTIONS
        guard let listURL = URL(string: "\(BaseURL)/api/plaid/transactions?email=\(email)") else {
            completion([])
            return
        }

        URLSession.shared.dataTask(with: listURL) { data, _, error in
            guard let data = data, error == nil else {
                completion([])
                return
            }

            do {
                let decoded = try JSONDecoder().decode([Transaction].self, from: data)
                DispatchQueue.main.async { completion(decoded) }
            } catch {
                print("❌ decode error:", error)
                DispatchQueue.main.async { completion([]) }
            }

        }.resume()

    }.resume()
}
 
struct NetResponse: Decodable {
    let net: Double
}


func fetchNetValue(
    auth: AuthManager,
    completion: @escaping (Double) -> Void
) {
    guard let email = auth.email.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
          let url = URL(string: "\(BaseURL)/api/plaid/net?email=\(email)") else {
        completion(0.0)
        return
    }

    URLSession.shared.dataTask(with: url) { data, _, error in
        if let error = error {
            print("❌ Net fetch error:", error.localizedDescription)
            completion(0.0)
            return
        }

        guard let data = data else {
            print("❌ No data returned for net value")
            completion(0.0)
            return
        }

        do {
            // Decode JSON: { "net": -123.45 }
            let decoded = try JSONDecoder().decode(NetResponse.self, from: data)

            print("📊 Net spending value:", decoded.net)

            DispatchQueue.main.async { completion(decoded.net) }

        } catch {
            print("❌ JSON decode error:", error)
            print("Server raw response:", String(data: data, encoding: .utf8) ?? "")
            DispatchQueue.main.async { completion(0.0) }
        }

    }.resume()
}

