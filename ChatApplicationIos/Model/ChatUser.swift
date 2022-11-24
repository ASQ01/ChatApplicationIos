//
//  ChatUser.swift
//  ChatApplicationIos
//
//  Created by Álvaro Antonio Suárez Quintana on 19/11/22.
//

import Foundation

struct ChatUser: Identifiable {
    
    var id: String { uid }
    let email, name, uid : String
    
    init (data: [String: Any]){
        self.email = data["email"] as? String ?? ""
        self.name = data["name"] as? String ?? ""
        self.uid = data["uid"] as? String ?? ""
    }
}
