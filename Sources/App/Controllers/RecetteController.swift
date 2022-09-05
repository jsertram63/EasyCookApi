//
//  File.swift
//  
//
//  Created by Lunack on 29/08/2022.
//

import Foundation
import Vapor
struct RecetteController: RouteCollection{
    func boot(routes: RoutesBuilder) throws {
        let recettes = routes.grouped("recette")
        recettes.get(use: index)
        recettes.post(use:create)
    }
    //CRUD
    // get : index
    func index(req: Request) throws -> EventLoopFuture<[Recette]>{
        return Recette.query(on: req.db).all()
    }
    // post : create
    func create(req:Request) throws -> EventLoopFuture<HTTPStatus> {
        let recette = try req.content.decode(Recette.self)
        return recette
            .save(on: req.db)
            .transform(to: .ok) // 200 si OK
    }
}
