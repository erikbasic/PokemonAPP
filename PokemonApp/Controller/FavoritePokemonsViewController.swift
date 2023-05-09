import UIKit
import CoreData

class FavoritePokemonsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
  //  MARK: - Outlets
  @IBOutlet weak var tableView: UITableView!
  
  var favoritePokemons: [FavoritePokemon] = []
  private var selectedPokemon: FavoritePokemon?

  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    let favoritePokemons = FavoritePokemon.getAllPokemons()
    self.favoritePokemons = favoritePokemons
    tableView.reloadData()
  }
  
  
  // MARK: - UITableViewDataSource
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    favoritePokemons.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "FavoritePokemonCell", for: indexPath) as! FavoritePokemonCell
    let pokemon = favoritePokemons[indexPath.row]
    cell.favPokemonLabel.text = pokemon.pokemon.finalName
    return cell
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else {
        return
      }
      let pokemon = favoritePokemons[indexPath.row]
      do {
        try FavoritePokemon.removePokemon(id: pokemon.pokemonID, context: context)
        favoritePokemons.remove(at: indexPath.row)
      } catch {
        debugPrint(error)
      }
    }
  }
  
  func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
    tableView.deleteRows(at: [indexPath!], with: .middle)
  }

  
  // MARK: UITableViewDelegate
  
  func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    selectedPokemon = favoritePokemons[indexPath.row]
    return indexPath
  }
  
  
  // MARK: - Navigation
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showDetailsFromFavorites" {
      let pokemonDetailViewController = segue.destination as! PokemonDetailViewController
      pokemonDetailViewController.pokemon = selectedPokemon!.pokemon
    }
  }
  
}
