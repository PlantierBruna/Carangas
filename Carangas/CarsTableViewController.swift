//
//  CarsTableViewController.swift
//  Carangas
//
//  Copyright © 2020 Eric Brito. All rights reserved.
//

import UIKit

class CarsTableViewController: UITableViewController {
    
    var cars: [Car] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        CarAPI.loadCars { [weak self] (result) in
            
            guard let self = self else {return}
            
            switch result {
            case .success(let cars):
                self.cars = cars
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
                
           
            case .failure(let apiError):
                switch apiError {
                case .badResponse:
                    print("Não tem uma response")
                    
                default:
                    print("Outro Erro")
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? CarViewController{
            vc.car = cars[tableView.indexPathForSelectedRow!.row]
            
        }
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cars.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let car = cars[indexPath.row]
        cell.textLabel?.text = car.name
        cell.detailTextLabel?.text = car.brand
        
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let car = cars[indexPath.row]
            CarAPI.deleteCar(car) { (result) in
                switch result {
                case .success:
                    self.cars.remove(at: indexPath.row)
                    DispatchQueue.main.async {
                                            tableView.deleteRows(at: [indexPath], with: .fade)
                    }

                    
                    
                case .failure:
                    print("Errrrouuuuuu")
                    
                    
                }
            }
        }
        
    }



}


