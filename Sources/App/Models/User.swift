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
    
    
    @Children(for: \.$user)
    var recettes:[Recette]
    
  init() {}
    
  init(id: UUID? = nil, name: String, username: String) {
    self.name = name
    self.username = username
  }
}
