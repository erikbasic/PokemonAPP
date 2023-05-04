//
//  FavoritePokemon+CoreDataClass.swift
//  PokemonApp
//
//  Created by Erik Basic on 26.04.2023..
//
//

import Foundation
import CoreData
import UIKit

@objc(FavoritePokemon)
public class FavoritePokemon: NSManagedObject {
  
  static func getAllPokemons(context: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext) -> [FavoritePokemon] {
    do{
      let fetchRequest = FavoritePokemon.fetchRequest()
      let pokemon = try context.fetch(fetchRequest)
      
      
      return pokemon
    } catch{
      debugPrint(error)
      return []
    }
  }
  
  static func getPokemonWithId(_ pokemonId: Int64, context: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext) -> FavoritePokemon? {
    do {
      let fetchRequest = FavoritePokemon.fetchRequest()
      
      // Either use predicate or filter the whole set
      // 1. predicate
      let predicate = NSPredicate(format: "pokemonID = %i", pokemonId)
      fetchRequest.predicate = predicate
      let pokemon = try context.fetch(fetchRequest).first

      // 2. filter
//      let pokemons = try context.fetch(fetchRequest)
//      let pokemon = pokemons.first(where: { $0.pokemonID == pokemonId })
      
      return pokemon
    } catch {
      debugPrint(error)
      return nil
    }
  }
  
  static func savePokemon(id: Int64, name: String?, spriteURL: URL?, context: NSManagedObjectContext) throws {
    let newPokemon = FavoritePokemon(context: context)
    newPokemon.pokemonID = id
    newPokemon.pokemonName = name
    newPokemon.spriteURL = spriteURL
    newPokemon.pokemonWeight = 0
    newPokemon.pokemonWeight = 0
    
    try context.save()
  }
  
  static func removePokemon(id: Int64, context: NSManagedObjectContext) throws {
    guard let pokemon = getPokemonWithId(id, context: context) else {
      return
    }
    context.delete(pokemon)
    
    try context.save()
  }
  
}
