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
        recettes.put(use:update)
        recettes.delete(use: delete)
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
    
    
    func update(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        
        // on construit une recette en fonction de ce que l'on va récupérer du body de la request
        let recetteToUpdate = try req.content.decode(Recette.self)
        
        return Recette
            // on va chercher s'il existe une recette dans la db qui recetteToUpdate
            .find(recetteToUpdate.id, on: req.db)
            // si une recette trouvé en db il a la déballe sinon il renvoie un httpStatus notfound
            .unwrap(or: Abort(.notFound))
            
            // mise a jour
            .flatMap {
                $0.name = recetteToUpdate.name
                $0.imageURL = recetteToUpdate.imageURL
                $0.description = recetteToUpdate.description
            
            // sauvegarder en db
                return $0
                    .update(on: req.db)
                    .transform(to: .ok)
            }
    }
    /* A finir*/
    /*
    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        guard let id = req.parameters.get("id", as: UUID.self) else {
            throw Abort(.badRequest)
        }
        return Todo.find(id, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .map { .ok }
    }*/
    
}
