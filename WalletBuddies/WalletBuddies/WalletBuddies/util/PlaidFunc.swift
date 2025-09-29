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
let BaseURL = "https://d325e5b5824d.ngrok-free.app"  // your Mac’s LAN IP for iPhone testing
#endif

// MARK: - Networking helpers

func fetchLinkToken(completion: @escaping (String?) -> Void) {
    guard let url = URL(string:  "\(BaseURL)/api/create_link_token") else {
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
    guard let url = URL(string: "\(BaseURL)/api/exchange_public_token") else {
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


//
//  PlaidService.swift
//  WalletBuddies
//



// Simple Transaction model (expand later)
struct Transaction: Identifiable {
    let id = UUID()   // always generates a new UUID when you make one
    let name: String?
    let amount: Double?
}

// MARK: - Plaid API Helpers
func fetchTransactions(completion: @escaping ([Transaction]) -> Void) {
    guard let url = URL(string: "\(BaseURL)/api/transactions") else {
        completion([])
        return
    }

    URLSession.shared.dataTask(with: url) { data, _, error in
        guard let data = data, error == nil else {
            print("❌ transactions fetch error:", error?.localizedDescription ?? "unknown")
            completion([])
            return
        }
        
        do {
            // For now, Plaid returns a big dictionary
            // We’ll just parse the transactions array if it exists
            if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
               let transactions = json["transactions"] as? [[String: Any]] {
                
                // Map minimal fields into our Swift struct
                let mapped = transactions.map { txn in
                    Transaction(
                        name: txn["name"] as? String,
                        amount: txn["amount"] as? Double
                    )
                }
                
                DispatchQueue.main.async {
                    completion(mapped)
                }
            } else {
                print("❌ bad transaction response:", String(data: data, encoding: .utf8) ?? "")
                DispatchQueue.main.async {
                    completion([])
                }
            }
        } catch {
            print("❌ json decode error:", error)
            DispatchQueue.main.async {
                completion([])
            }
        }
    }.resume()
}
