//
//  File 2.swift
//  
//
//  Created by Lunack on 12/09/2022.
//

import Fluent

struct CreateIngredient: Migration {
    
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("ingredients")
            .id()
            .field("name", .string, .required)
            .field("recetteID", .uuid)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("ingredients").delete()
    }
}
