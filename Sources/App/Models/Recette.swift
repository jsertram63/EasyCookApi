//
//  File.swift
//  
//
//  Created by Lunack on 29/08/2022.
//

import Foundation
import Vapor
import Fluent

final class Recette: Model, Content {
    init() {}
    // Schéma de la table Recette
    static var schema: String = "recette"
    
    // Champ id (colonne)
    @ID(key: .id)
    var id: UUID?
    
    // Champ name
    @Field(key: "name")
    var name: String
    
    // Champ imageURL
    @Field(key:"imageURL")
    var imageURL: String
    
    // Champ description
    @Field(key: "description")
    var description: String
    
    // Champ favorite
    @Field(key: "favoris")
    var favoris: Bool
    
    @Parent(key: "userID")
    var user: Utilisateur
    
    @Children(for: \.$recette)
    var ingredients: [Ingredient]
    
    init(id:UUID? = nil, name: String, imageURL: String, description: String, favoris: Bool, userID: Utilisateur.IDValue){
        self.id = id
        self.name = name
        self.imageURL = imageURL
        self.description = description
        self.favoris = favoris
        self.$user.id = userID
    }
}
