//
//  QuerryService.swift
//  PokemonApp
//
//  Created by Erik Basic on 25.04.2023..
//

import Foundation


//
// MARK: - Query Service
//

// sluzi mi za trazenje pokemona, te spremanje rezultata u array Pokemon

class QueryService {
  
  // MARK: - Constants
  
  let defaultSession = URLSession(configuration: .default) // stvaranje defaultne URL sesije
  
  //  MARK: - Variables And Properties
  
  var dataTask: URLSessionDataTask?
  var errorMessage = ""
  var pokemons: [Pokemon] = []
  
  //  MARK: - Type Alias
  typealias JSONDictionary = [String: Any]
  typealias QueryResult = ([Pokemon]?, String) -> Void
  
  
  //  MARK: - Methods
  
  func getPokemons(completion: @escaping ([Pokemon], String) -> ()) {
    dataTask?.cancel()
    
    if let urlComponents = URLComponents(string: "https://pokeapi.co/api/v2/pokemon/") {
      guard let url = urlComponents.url else {
        return
      }
      
      dataTask = defaultSession.dataTask(with: url) { [weak self] data, response, error in
        defer {
          self?.dataTask = nil
        }
        
        if let error = error {
          self?.errorMessage += "DataTask error: " + error.localizedDescription + "\n"
        } else if
          let data = data,
          let response = response as? HTTPURLResponse,
          response.statusCode == 200
        {
          self?.parsePokemonJsonFromData(data)
          
          DispatchQueue.main.async {
            completion(self?.pokemons ?? [], self?.errorMessage ?? "")
          }
        }
      }
      dataTask?.resume()
    }
  }
  
  
  // MARK: - Private Methods
  
  private func parsePokemonJsonFromData(_ data: Data) {
    var response: JSONDictionary?
    pokemons.removeAll()
    
    do {
      response = try JSONSerialization.jsonObject(with: data, options: []) as? JSONDictionary
    } catch {
      errorMessage += "JSONSerialization error: \(error.localizedDescription)\n"
      return
    }
    
    guard let array = response!["results"] as? [Any] else {
      errorMessage += "Dictionary does not contain results key\n"
      return
    }
        
    for pokemonDictionary in array {  // za svaki dictionary  arrayu
      if
        let pokemonDictionary = pokemonDictionary as? JSONDictionary, // provjera je li ovo json dictionary
        let pokemonName = pokemonDictionary["name"] as? String
      {
        let pokemon = Pokemon(name: pokemonName, imageUrl: nil)
        pokemons.append(pokemon)
      } else {
        errorMessage += "Problem parsing pokemonDictionary\n"
      }
    }
  }
}
