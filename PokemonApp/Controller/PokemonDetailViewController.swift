//
//  PokemonDetailViewController.swift
//  PokemonApp
//
//  Created by Erik Basic on 26.04.2023..
//

import UIKit

class PokemonDetailViewController: UIViewController {
  @IBOutlet weak var pokemonImageView: UIImageView!
  var pokemon: Pokemon!
  private var favoriteButton: UIBarButtonItem!
  private let queryService = QueryService()
  
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
    
    queryService.getPokemonImage { (pokemonImage: UIImage?) in
      if let pokemonImage = pokemonImage {
        self.pokemonImageView.image = pokemonImage
      }
    }
  }
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destination.
   // Pass the selected object to the new view controller.
   }
   */
  
  
  // MARK: - Selectors
  
  @objc private func toggleFavorite(sender: UIBarButtonItem) {
    let isFavorite = pokemon.isFavorite
    pokemon.isFavorite = !isFavorite
    favoriteButton.image = UIImage(systemName: "star")
    if pokemon.isFavorite {
      favoriteButton.image = UIImage(systemName: "star.fill")
    }
  }
  
}
