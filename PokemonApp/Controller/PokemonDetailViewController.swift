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
  
  var pokemon: PokemonBase!
  var pokemonDetails: Pokemon!
  private var favoriteButton: UIBarButtonItem!
  private let queryService = QueryService()
  private let detailQuery = DetailQueryService()
  var favoritePokemons: [NSManagedObject] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    
    title = pokemon.finalName
    favoriteButton = navigationItem.rightBarButtonItem
    if pokemon.isFavorite {
      favoriteButton.image = UIImage.init(systemName: "star.fill")
    }
    favoriteButton.target = self
    favoriteButton.action = #selector(toggleFavorite(sender:))
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    activityIndicator.startAnimating()
    //    Load data source for detail
    detailQuery.getPokemonDetailsFor(pokemon) { pokemon, errorString in
      if let pokemon = pokemon,
         let pokemonWeight = pokemon.pokemonWeight{
        // dynamic weight
        self.weightLabel.text = "Weight: \(pokemonWeight)"
        
      }
      if let pokemon = pokemon,
         let pokemonXP = pokemon.pokemonExp{
        self.xpLabel.text = "Base XP: \(pokemonXP)"
      }
      // dynamic image
      let url = pokemon?.spriteUrl
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
    
    
    let isFavorite = pokemon.isFavorite
    pokemon.isFavorite = !isFavorite
    // realizirati upis, tj brisanje podataka
    if pokemon.isFavorite == true{
      print("Upis")
      detailQuery.getPokemonDetailsFor(pokemon) { pokemon, errorString in
        self.saveToCoreData(favID: pokemon!.pokemonID!, favWeight: pokemon!.pokemonWeight!, favURL: pokemon!.spriteUrl!, favName: pokemon!.finalName, favExp: pokemon!.pokemonExp!, isFav: pokemon!.isFavorite)
      }
      }else{
      print("Brisanje")
    }
    favoriteButton.image = UIImage(systemName: "star")
    if pokemon.isFavorite {
      favoriteButton.image = UIImage(systemName: "star.fill")
    }
  }
  
  func saveToCoreData(favID: Int, favWeight: Int, favURL: URL, favName: String, favExp: Int, isFav: Bool){
    guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else{
      return
    }
    
    let managedContext = appDelegate.persistentContainer.viewContext
    
    let entity = NSEntityDescription.entity(forEntityName: "FavoritePokemon", in: managedContext)!
    
    let favoritePokemon = NSManagedObject (entity: entity, insertInto: managedContext)
    
    favoritePokemon.setValue(favID, forKey: "pokemonID")
    favoritePokemon.setValue(favWeight, forKey: "pokemonWeight")
    favoritePokemon.setValue(favURL, forKey: "spriteURL")
    favoritePokemon.setValue(favName, forKey: "pokemonName")
    favoritePokemon.setValue(favExp, forKey: "pokemonExp")
    favoritePokemon.setValue(isFav, forKey: "isFavorite")
    
    
    do{
      try managedContext.save()
      favoritePokemons.append(favoritePokemon)
    } catch{
      print("Could not save.")
    }
  }
}

