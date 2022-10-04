//
//  File.swift
//  
//
//  Created by Lunack on 29/08/2022.
//

import Foundation
import Fluent

struct CreateRecette : Migration {
    // besoin de deux méthodes pour créer migration
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database
            .schema("recette")
            .id()
            .field("name", .string, .required)
            .field("imageURL", .string, .required)
            .field("description", .string, .required)
            .field("favoris", .bool, .required)
            .field("userID", .uuid, .required, .references("utilisateurs", "id"))
            .create()
    }
    
    // pour supprimer
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("recette").delete()
    }
}
