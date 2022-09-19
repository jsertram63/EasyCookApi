//
//  File.swift
//  
//
//  Created by Lunack on 12/09/2022.
//

import Foundation
import Fluent
import Vapor

final class Ingredient: Model, Content {
    init() {
    }
    static var schema = "ingredients"
    
    @ID
    var id:UUID?
    
    @Field(key:"name")
    var name:String
    
    // relation Parent - enfants // Décorateur
    @Parent(key:"recetteID")
    var recette:Recette
    
    
    init(id: UUID? = nil, name: String, recetteID: Recette.IDValue) {
        self.id = id
        self.name = name
        self.$recette.id = recetteID
    }
    
}






