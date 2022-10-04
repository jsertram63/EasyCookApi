//
//  File.swift
//  
//
//  Created by Lunack on 25/09/2022.
//

import Foundation
import Fluent
import Vapor

final class Utilisateur: Model, Content {
  static let schema = "utilisateurs"

  @ID
  var id: UUID?
  @Field(key: "name")
  var name: String
  @Field(key: "username")
  var username: String
    @Field(key:"password")
    var password:String
    
    @Children(for: \.$user)
    var recettes:[Recette]
  init() {}
    
    init(id: UUID? = nil, name: String, username: String, password:String) {
    self.name = name
    self.username = username
        self.password = password
  }
    
    final class Public: Content {
        var id:UUID?
        var name:String
        var username: String
        
        init(id:UUID?, name: String, username: String){
            self.id = id
            self.name = name
            self.username = username
        }
    }

}


extension Utilisateur   {
    func convertToPublic() -> Utilisateur.Public {
        
        return Utilisateur.Public(id: id, name: name, username: username)
    }
}

extension EventLoopFuture where  Value: Utilisateur {
    
    func convertToPublic() -> EventLoopFuture<Utilisateur.Public> {
        return self.map { utilisateur in
            return utilisateur.convertToPublic()
        }
    }
}

extension Collection where Element : Utilisateur {
    func convertToPublic() -> [Utilisateur.Public]{
        return self.map { $0.convertToPublic() }
    }
}

extension EventLoopFuture where Value == Array<Utilisateur> {
  func convertToPublic() -> EventLoopFuture<[Utilisateur.Public]> {
    return self.map { $0.convertToPublic() }
  }
}

extension Utilisateur: ModelAuthenticatable {
  // 2
  static let usernameKey = \Utilisateur.$username
  // 3
  static let passwordHashKey = \Utilisateur.$password

  // 4
  func verify(password: String) throws -> Bool {
    try Bcrypt.verify(password, created: self.password)
  }
}
