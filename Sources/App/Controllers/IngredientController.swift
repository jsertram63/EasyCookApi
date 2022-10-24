//
//  File.swift
//  
//
//  Created by Lunack on 12/09/2022.
//

import Foundation
import Foundation
import Vapor
struct IngredientController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        let ingredients = routes.grouped("ingredients")
        
        let basicAuthMiddleware = Utilisateur.authenticator()
        // 2
        let guardAuthMiddleware = Utilisateur.guardMiddleware()
        
        ingredients.get(use: index)
        ingredients.post(use: create)
        ingredients.put(use: update)
        
        ingredients.group(":ingredientID") { ingredient in
            ingredient.delete(use: delete)
        }
        
        // 3
        //let protected = ingredients.grouped(
        //    basicAuthMiddleware,
        //    guardAuthMiddleware)
        // 4
        //protected.post(use: create)
    }
    
    
    // localhost/ingredients
    func index(req: Request) throws -> EventLoopFuture<[Ingredient]>{
        return Ingredient.query(on: req.db).all()
    }
    
    func create(req: Request) throws -> EventLoopFuture<Ingredient> {
        // on construit le data DTO avec le body
        let data = try req.content.decode(CreateRecetteData.self)
        let ingredient = Ingredient(
            name: data.name, recetteID: data.recetteID)
        return ingredient.save(on: req.db).map{ ingredient}
    }
    
    
    func update(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        
        // on construit une recette en fonction de ce que l'on va récupérer du body de la request
        let ingredientToUpdate = try req.content.decode(Ingredient.self)
        
        return Ingredient
        // on va chercher s'il existe une recette dans la db qui recetteToUpdate
            .find(ingredientToUpdate.id, on: req.db)
        // si une recette trouvé en db il a la déballe sinon il renvoie un httpStatus notfound
            .unwrap(or: Abort(.notFound))
        
        // mise a jour
            .flatMap {
                $0.name = ingredientToUpdate.name
                // sauvegarder en db
                return $0
                    .update(on: req.db)
                    .transform(to: .ok)
            }
    }
    
    func delete(req: Request) throws ->
    EventLoopFuture<HTTPStatus>{
        
        Ingredient
        // recherche une recette en fonction de ce qu'on se passe dans l'url
            .find(req.parameters
                  // récupération de la recette avec l'id
                .get("ingredientID"), on: req.db)
        // on la déballe si trouvé sinon on renvoie un status d'errer
            .unwrap(or: Abort(.notFound))
        // suppression en base de données
            .flatMap{$0.delete(on: req.db)
                    .transform(to: .ok)
            }
    }
}

// DTO : Data Transfert Object -> Définir l'objet à partir du body
struct CreateRecetteData: Content {
    let name: String
    let recetteID: UUID
}
