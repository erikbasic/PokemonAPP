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
  
  var basePokemon: PokemonBase!
  private var pokemon: Pokemon!
  private var favoriteButton: UIBarButtonItem!
  private let queryService = QueryService()
  private let detailQuery = DetailQueryService()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    
    title = basePokemon.finalName
    favoriteButton = navigationItem.rightBarButtonItem
    favoriteButton.target = self
    favoriteButton.action = #selector(toggleFavorite(sender:))
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    activityIndicator.startAnimating()
    //    Load data source for detail
    detailQuery.getPokemonDetailsFor(basePokemon) { pokemon, errorString in
      guard let pokemon = pokemon else {
        return
      }
      if let pokemonWeight = pokemon.pokemonWeight {
        // dynamic weight
        self.weightLabel.text = "Weight: \(pokemonWeight)"
        
      }
      if let pokemonXP = pokemon.pokemonExp {
        self.xpLabel.text = "Base XP: \(pokemonXP)"
      }
      
      self.updateFavoriteButtonImageForPokemon(pokemon)
      
      // dynamic image
      let url = pokemon.spriteUrl
      DispatchQueue.global().async{
        let data = try? Data(contentsOf: url!)
        DispatchQueue.main.async {
          self.pokemonImageView.image = UIImage(data: data!)
          self.activityIndicator.stopAnimating()
        }
      }
      
      self.pokemon = pokemon
    }
  }
  
  // MARK: - Selectors
  
  // 1. Provjeri Core Datu preko ID-a -> Pokemon nije favorite -> Pokazi praznu zvijezdicu
  // Ukoliko pritisnemo zvijezdicu -> isFavorite postaje True -> Spremi ga u Core Datu
  //  2. Provjeri CoreD Datu preko ID-a - Pokemon je favorite -> Pokazi punu zvijezdicu
  //  Pritisnemo zvijezdicu -> isFavorite postaje False -> Brisi ga iz Core Date
  
  
  
  
  @objc private func toggleFavorite(sender: UIBarButtonItem) {
    //    case 1: isFavorite FALSE -- pokemon.isFavorite FALSE
    //            isFavorite FALSE -- pokemon.isFavorite TRUE
    //     Ovdje se radi sigurno o upisu
    //    case 2: isFavorite TRUE - pokemon.isFavorite TRUE
    //            isFavorite TRUE - pokemon.isFavorite FALSE
    
    // Try to get this pokemon from CoreData
    // and check if favorite
    
    guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else {
      return
    }
    
    let isFavorite = pokemon.isFavorite
    
    
    pokemon.isFavorite = !isFavorite
    // realizirati upis, tj brisanje podataka
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

