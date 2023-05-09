//
//  PokemonDetailViewController.swift
//  PokemonApp
//
//  Created by Erik Basic on 26.04.2023..
//

import UIKit
import CoreData

class PokemonDetailViewController: UIViewController {
  @IBOutlet weak var pokemonImageView: UIImageView!
  @IBOutlet weak var weightLabel: UILabel!
  
  @IBOutlet weak var xpLabel: UILabel!
  
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  
  var pokemon: Pokemon!
  private var favoriteButton: UIBarButtonItem!
  private let queryService = QueryService()
  private let detailQuery = DetailQueryService()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    
    title = pokemon.finalName
    favoriteButton = navigationItem.rightBarButtonItem
    favoriteButton.target = self
    favoriteButton.action = #selector(toggleFavorite(sender:))
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    activityIndicator.startAnimating()
    //    Load data source for detail
    detailQuery.getPokemonDetailsFor(pokemon) { pokemonDetails, errorString in
      guard let pokemonDetails = pokemonDetails else {
        return
      }
      if let pokemonID = pokemonDetails.pokemonID {
        self.pokemon.pokemonID = pokemonID
      }
      if let pokemonWeight = pokemonDetails.pokemonWeight {
        // dynamic weight
        self.weightLabel.text = "Weight: \(pokemonWeight)"
        self.pokemon.pokemonWeight = pokemonWeight
      }
      if let pokemonXP = pokemonDetails.pokemonExp {
        self.xpLabel.text = "Base XP: \(pokemonXP)"
        self.pokemon.pokemonExp = pokemonXP
      }
      if let pokemonIsFavorite = pokemonDetails.isFavorite {
        self.pokemon.isFavorite = pokemonIsFavorite
      }
      self.updateFavoriteButtonImageForPokemon(self.pokemon)
      
      // dynamic image
      let url = pokemonDetails.spriteUrl
      self.pokemon.spriteUrl = url
      DispatchQueue.global().async{
        let data = try? Data(contentsOf: url!)
        DispatchQueue.main.async {
          self.pokemonImageView.image = UIImage(data: data!)
          self.activityIndicator.stopAnimating()
        }
      }
    }
  }
  
  // MARK: - Selectors

  @objc private func toggleFavorite(sender: UIBarButtonItem) {

    
    guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else {
      return
    }
    
    let isFavorite = pokemon.isFavorite
    
    
    pokemon.isFavorite = !isFavorite
    if pokemon.isFavorite == true {
      // Save pokemon to CoreData
      do {
        try FavoritePokemon.savePokemon(id: pokemon.pokemonID, name: pokemon.name, spriteURL: pokemon.spriteUrl, context: context)
      } catch {
        debugPrint(error)
      }
    } else {
      // Remove pokemon from CoreData
      print("Brisanje")
      do {
        try FavoritePokemon.removePokemon(id: pokemon.pokemonID, context: context)
      } catch {
        debugPrint(error)
      }
    }
    
    // Update UI
    updateFavoriteButtonImageForPokemon(pokemon)
  }
  
  private func updateFavoriteButtonImageForPokemon(_ pokemon: Pokemon) {
    if pokemon.isFavorite {
      favoriteButton.image = UIImage.init(systemName: "star.fill")
    } else {
      favoriteButton.image = UIImage.init(systemName: "star")
    }
  }
}

