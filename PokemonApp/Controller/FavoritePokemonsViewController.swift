import UIKit
import CoreData

class FavoritePokemonsViewController: UIViewController, UITableViewDataSource {
  
  
  //  MARK: - Outlets
  @IBOutlet weak var tableView: UITableView!
  
  
  var favoritePokemon: [NSManagedObject] = []
  private var favoritePokemons = [FavoritePokemon]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    
    guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else{
      return
    }
    let managedContext = appDelegate.persistentContainer.viewContext
    
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavoritePokemon")
    
    do{
      favoritePokemon = try managedContext.fetch(fetchRequest)
    } catch{
      print("Could not fetch")
    }
  }
  
  //    MARK: - UITableViewDataSorce
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    favoritePokemon.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "FavoritePokemonCell", for: indexPath) as! FavoritePokemonCell
    let pokemon = favoritePokemons[indexPath.row]
    cell.favPokemonLabel.text = pokemon.pokemonName
    return cell
  }
}
