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
        recettes.post(use: create)
        recettes.put(use: update)
        recettes.group(":recetteID") { recette in
            recette.delete(use:delete)
        }
        
        // nouveau commentaire
        //
        recettes.get(":recetteID", use: getHandler)
        
        //        let basicAuthMiddleware = Utilisateur.authenticator()
        //        // 2
        //        let guardAuthMiddleware = Utilisateur.guardMiddleware()
        //        // 3
        //        let protected = recettes.grouped(
        //            basicAuthMiddleware,
        //            guardAuthMiddleware
        //        )
        //        // 4
        //        protected.post(use: create)
    }
    
    /* **************************************** CRUD *************************** */
    
    // get : index
    func index(req: Request) throws -> EventLoopFuture<[Recette]> {
        return Recette.query(on: req.db)
            .with(\.$ingredients).all()
        
        
    }
    // post : create
    func create(req:Request) throws -> EventLoopFuture<HTTPStatus> {
        
        let data = try req.content.decode(CreateRecetteUserData.self)
        
        let recette = Recette(
            name: data.name,
            imageURL: data.imageURL,
            description: data.description,
            categorie: data.categorie,
            favoris: data.favoris,
            userID: data.userID
        )
        
        //let recette = try req.content.decode(Recette.self)
        return recette
            .save(on: req.db).map { recette }
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
                $0.categorie = recetteToUpdate.categorie
                $0.favoris = recetteToUpdate.favoris
                
                // sauvegarder en db
                return $0
                    .update(on: req.db)
                    .transform(to: .ok)
            }
    }
    
    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        Recette
        // recherche une recette en fonction de ce qu'on se passe dans l'url
            .find(req.parameters
                  // récupération de la recette avec l'id
                .get("recetteID"), on: req.db)
        // on la déballe si trouvé sinon on renvoie un status d'errer
            .unwrap(or: Abort(.notFound))
        // suppression en base de données
            .flatMap{$0.delete(on: req.db)
                    .transform(to: .ok)
            }
    }
    
    func getHandler(_ req: Request) -> EventLoopFuture<Recette> {
        // 4
        Recette.find(req.parameters.get("recetteID"), on: req.db)
            .unwrap(or: Abort(.notFound))
    }
    
    func getUserHandler(_ req: Request)
    -> EventLoopFuture<Utilisateur.Public> {
        Recette.find(req.parameters.get("recetteID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { recette in
                // 2
                recette.$user.get(on: req.db).convertToPublic()
            }
    }
}

struct CreateRecetteUserData: Content {
    let userID: UUID
    let name: String
    let imageURL: String
    let description: String
    let categorie: String
    let favoris: Bool
}
