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

class QueryService{
  
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
  // funkcija za dohvacanje rezultata, GET metoda
  func getSearchResults (searchTerm: String, completion: @escaping QueryResult){
    dataTask?.cancel()
    
    if var urlComponents = URLComponents(string:"https://pokeapi.co/api/v2"){
      urlComponents.query = "pokemon/\(searchTerm)"
      
      guard let url = urlComponents.url else{
        return
      }
      
      dataTask = defaultSession.dataTask(with: url) { [weak self] data, response, error in
        defer{
          self?.dataTask = nil
        }
        
        if let error = error {
          self?.errorMessage += "DataTask error: " + error.localizedDescription + "\n"
        } else if
          let data = data,
          let response = response as? HTTPURLResponse,
          response.statusCode == 200 {
          
          self?.updateSearchResults(data)
          
          // 6
          DispatchQueue.main.async {
            completion(self?.pokemons, self?.errorMessage ?? "")
          }
        }
      }
      dataTask?.resume()
    }
    
  }
  
  // MARK: - Private Methods
  
  private func updateSearchResults(_ data: Data){
    var response: JSONDictionary?
    pokemons.removeAll()
    
    do {
      response = try JSONSerialization.jsonObject(with: data, options: []) as? JSONDictionary
    } catch let parseError as NSError {
      errorMessage += "JSONSerialization error: \(parseError.localizedDescription)\n"
      return
    }
    
    guard let array = response!["results"] as? [Any] else {
      errorMessage += "Dictionary does not contain results key\n"
      return
    }
    
    var index = 0
    
    for pokemonDictionary in array{  // za svaki dictionary  arrayu
      if let pokemonDictionary = pokemonDictionary as? JSONDictionary, // provjera je li ovo json dictionary
         let previewName = pokemonDictionary["name"] as? String{
        pokemons.append(Pokemon(name: previewName))
        index += 1
      } else{
        errorMessage += "Problem parsing pokemonDictionary\n"
      }
    }
  }
}
