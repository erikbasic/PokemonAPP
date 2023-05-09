//
//  DetailQueryService.swift
//  PokemonApp
//
//  Created by Erik Basic on 26.04.2023..
//

import Foundation
import UIKit
import CoreData

class DetailQueryService {
  
  // MARK: - Constants
  
  let defaultSession = URLSession(configuration: .default) // stvaranje defaultne URL sesije
  
  
  //  MARK: - Variables And Properties
  
  var dataTask: URLSessionDataTask?
  
  //  MARK: - Type Alias
  typealias JSONDictionary = [String: Any]
  
  
  //  MARK: - Methods
  
  // trebam nekako dohvatiti pokemon name
  func getPokemonDetailsFor(_ pokemon: Pokemon, completion: @escaping (PokemonDetails?, Error?) -> ()) {
    dataTask?.cancel()
    
    let pokemonName = pokemon.name!
    if let urlComponents = URLComponents(string: "https://pokeapi.co/api/v2/pokemon/\(pokemonName)/") {
      guard let url = urlComponents.url else {
        let error = PokeError.apiError("URL missing in request!")
        completion(nil, error)
        return
      }
      dataTask = defaultSession.dataTask(with: url) { [weak self] data, response, error in
        defer {
          self?.dataTask = nil
        }
        
        if let error = error {
          let error = PokeError.apiError("DataTask error: " + error.localizedDescription)
          DispatchQueue.main.async {
            completion(nil, error)
            return
          }
        } else if
          let data = data,
          let response = response as? HTTPURLResponse,
          response.statusCode == 200
        {
          // OK
          DispatchQueue.main.async {
            do {
              let pokemonDetails = try self?.parsePokemonDetailsJsonFromData(data, forPokemon: pokemon)
              completion(pokemonDetails, nil)
              return
            } catch {
              completion(nil, error)
              return
            }
          }
        } else {
          DispatchQueue.main.async {
            completion(nil, error)
          }
        }
      }
      dataTask?.resume()
    }
  }
  
  private func parsePokemonDetailsJsonFromData(_ data: Data, forPokemon pokemon: Pokemon) throws -> PokemonDetails {
    var response: JSONDictionary?
    
    do {
      response = try JSONSerialization.jsonObject(with: data, options: []) as? JSONDictionary
    } catch {
      throw error
    }
    
    guard let pokemonWeight  = response!["weight"] as? Int else {
      let error = PokeError.parseError("Dictionary does not containt weight key!")
      throw error
    }
    
    guard let pokemonXp  = response!["base_experience"] as? Int else {
      let error = PokeError.parseError("Dictionary does not containt base experience key")
      throw error
    }
    
    guard let spritesJson = response!["sprites"] as? JSONDictionary else {
      let error = PokeError.parseError("Dictionary does not containt sprites key")
      throw error
    }
    
    guard let otherJson = spritesJson.first(where: { $0.key == "other" })?.value as? JSONDictionary else {
      let error = PokeError.parseError("Dictionary does not contain other key")
      throw error
    }
    
    guard let homeJson = otherJson.first(where: { $0.key == "home" })?.value as? JSONDictionary else {
      let error = PokeError.parseError("Dictionary does not contain home key")
      throw error
    }
    
    guard
      let frontDefaultString = homeJson.first(where: { $0.key == "front_default" })?.value as? String,
      let spriteUrl = URL(string: frontDefaultString) else
    {
      let error = PokeError.parseError("Dictionary does not containt front default key")
      throw error
    }
    
    guard let pokemonID = response!["id"] as? Int64 else {
      let error = PokeError.parseError("Dictionary does not contain ID key")
      throw error
    }
    var pokemonDetails = PokemonDetails()
    pokemonDetails.spriteUrl = spriteUrl
    pokemonDetails.pokemonWeight = pokemonWeight
    pokemonDetails.pokemonExp = pokemonXp
    pokemonDetails.pokemonID = pokemonID
    
    // Check if the pokemon is already saved in CoreData,
    // which means it's a favorite pokemon
    if let _ = FavoritePokemon.getPokemonWithId(pokemonID) {
      pokemonDetails.isFavorite = true
    }
    
    return pokemonDetails
  }
  
}
