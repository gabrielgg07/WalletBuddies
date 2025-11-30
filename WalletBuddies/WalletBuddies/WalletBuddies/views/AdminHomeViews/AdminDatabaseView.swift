//
//  AdminDatabaseView.swift
//  WalletBuddies
//
//  Created by Gia Subedi on 11/15/25.
//

import SwiftUI

struct UserResponse : Codable{
    let success : Bool
    let Users : [User]
}

struct User: Identifiable,Codable{
    let id : Int
    let name : String
    let email : String
    let role : String
}

struct AdminDatabaseView: View {
    @EnvironmentObject var auth: AuthManager
    @State private var tryDelete = false
    @State private var tryModify = false
    @State private var userEmail: String = ""
    @State private var users:[User] = []
    
    var body: some View {
        
        VStack{
            
            List(users){user in
                HStack{
                    VStack(alignment: .leading){
                        Text("User ID: \(user.id)")
                            .font(.caption)
                        //                            .background(.yellow)
                            .padding(.vertical,4)
                        
                        
                        Text(user.email)
                            .font(.caption)
                            .padding(.vertical,5)
                        
                        Text("Role : \(user.role)")
                            .font(.caption)
                        
                    }
                    
                    
                    //                    Text("User XP")
                    //                        .font(.caption)
                    Spacer()
                    
                    
                    Button("Modify Role"){
                        userEmail = user.email
                        tryModify = true
                    }
                    .font(.caption)
                    .fontWeight(.bold)
                    .buttonStyle(.bordered)
                    .controlSize(.small)
                    .foregroundStyle(.white)
                    .background(Color.green)
                    .cornerRadius(6)
                    .frame(width: 70 ,height:50 )
                    .alert(isPresented:$tryModify){Alert(title:Text("Modify account role"),message:Text("Are you sure you want to change the account privileges for \(userEmail)? "),
                            primaryButton: .default(Text("Cancel")),
                            secondaryButton: .destructive(Text("Modify")){
                                modifyAccountPrivileges(email: userEmail)
                            }
                    
                )}
                    
                    Button("Delete User"){
                        userEmail = user.email
                        tryDelete = true
                    }
                    .font(.caption)
                    .fontWeight(.bold)
                    .buttonStyle(.bordered)
                    .controlSize(.small)
                    .foregroundStyle(.white)
                    .background(Color.red)
                    .cornerRadius(6)
                    .frame(width: 70 ,height:50 )
                    .alert(isPresented:$tryDelete){
                        Alert(title:Text("Delete account"),
                              message:Text("Are you sure you want to delete your account? "),
                              primaryButton: .default(Text("Cancel")),
                              secondaryButton: .destructive(Text("Delete")){
                                deleteAcc(email: userEmail)
                            }
                    
                )}
            }
            
        }
        .onAppear{
            getUsers()
        }
                  
            
        }
        
    }
    
    func getUsers(){
        guard let loginURL = URL(string:"http://127.0.0.1:5001/api/users/getAllUsers") else {return}
        var sendRequest = URLRequest(url : loginURL)
        sendRequest.httpMethod = "GET"
        sendRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        URLSession.shared.dataTask(with: sendRequest){ data, response, error in
            if (error != nil){
                print("Error!")
                return
            }

            guard let data = data else { return }

            do {
                let decoded = try JSONDecoder().decode(UserResponse.self, from: data)

                if decoded.success{
                    DispatchQueue.main.async {
                        self.users = decoded.Users.sorted{ $0.id < $1.id}
                    }
                } else {
                    print("❌ Not found")
                }

            } catch {
                print("❌ Decode error: \(error)")
                print(String(data: data, encoding: .utf8) ?? "")
            }
        }.resume()
}
   
    func deleteAcc(email:String){
        auth.deleteAccountAsAdmin(accountEmail : email){ success in
            if success{
                getUsers()
            }
        }
    }
    
    func modifyAccountPrivileges(email:String){
        auth.modifyAccountAsAdmin(accountEmail : email){ success in
            if success{
                getUsers()
            }
        }
    }

}


#Preview {
    AdminDatabaseView()
}
