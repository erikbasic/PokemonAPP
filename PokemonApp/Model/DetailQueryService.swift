//
//  DetailQueryService.swift
//  PokemonApp
//
//  Created by Erik Basic on 26.04.2023..
//

import Foundation
import UIKit

class DetailQueryService{
  
  // MARK: - Constants
  
  let defaultSession = URLSession(configuration: .default) // stvaranje defaultne URL sesije
  
  
  //  MARK: - Variables And Properties
  
  var dataTask: URLSessionDataTask?
  var errorMessage = ""
  var pokemonsDetails: [DetailsOfPokemon] = []
  
  //  MARK: - Type Alias
  typealias JSONDictionary = [String: Any]
  typealias DetailQueryResult = ([DetailsOfPokemon]?, String) -> Void
  
  
  //  MARK: - Methods
  
  // trebam nekako dohvatiti pokemon name
  func getPokemonDetailsFor(_ pokemonBase: PokemonBase, completion: @escaping (Pokemon?, String?) -> ()) {
    dataTask?.cancel()
    
    let pokemonName = pokemonBase.name!
    if let urlComponents = URLComponents(string: "https://pokeapi.co/api/v2/pokemon/\(pokemonName)/") {
      guard let url = urlComponents.url else {
        return
      }
      dataTask = defaultSession.dataTask(with: url) { [weak self] data, response, error in
        defer {
          self?.dataTask = nil
        }
        
        if let error = error {
          self?.errorMessage += "DataTask error: " + error.localizedDescription + "\n"
          DispatchQueue.main.async {
            completion(nil, self?.errorMessage)
            return
          }
        } else if
          let data = data,
          let response = response as? HTTPURLResponse,
          response.statusCode == 200
        {
          // OK
          let pokemon = self?.parsePokemonDetailsJsonFromData(data, pokemonBase: pokemonBase)
          
          DispatchQueue.main.async {
            completion(pokemon, nil)
          }
        } else {
          DispatchQueue.main.async {
            completion(nil, self?.errorMessage)
          }
        }
      }
      dataTask?.resume()
    }
  }
  
  private func parsePokemonDetailsJsonFromData(_ data: Data, pokemonBase: PokemonBase) -> Pokemon? {
    
    var response: JSONDictionary?
    pokemonsDetails.removeAll()
    
    do {
      response = try JSONSerialization.jsonObject(with: data, options: []) as? JSONDictionary
    } catch {
      errorMessage += "JSONSerialization error: \(error.localizedDescription)\n"
      return nil
    }
    
    guard let pokemonWeight  = response!["weight"] as? Int else {
      errorMessage += "Dictionary does not containt weight key\n"
      return nil
    }
  
    guard let spritesJson = response!["sprites"] as? JSONDictionary else {
      errorMessage += "Dictionary does not contain sprites key\n"
      return nil
    }
    
    guard let otherJson = spritesJson.first(where: { $0.key == "other" })?.value as? JSONDictionary else {
      return nil
    }
    
    guard let homeJson = otherJson.first(where: { $0.key == "home" })?.value as? JSONDictionary else {
      return nil
    }
    
    guard
      let frontDefaultString = homeJson.first(where: { $0.key == "front_default" })?.value as? String,
      let spriteUrl = URL(string: frontDefaultString) else
    {
      return nil
    }
    
    
    let pokemon = Pokemon()
    pokemon.name = pokemonBase.name
    pokemon.spriteUrl = spriteUrl
    pokemon.pokemonWeight = pokemonWeight
    
    return pokemon
    
    
//    for (spriteJsonKey, spriteJsonValue) in spritesJson {
//      let i = 8
//      if
//        let otherJson = spriteJsonKey["other"] as? JSONDictionary,
//        let homeJson = otherJson["home"] as? JSONDictionary,
//        let frontDefaultJson = homeJson["front_default"] as? JSONDictionary
//      {
//        let i = 8
////        let pokemonDetail = DetailsOfPokemon(detailWeight: pokemonWeight, imageURL: pokemonURL)
////        pokemonsDetails.append(pokemonDetail)
//      }else{
//        errorMessage += "Problem parsing urlArray"
//      }
//    }
  }
}
