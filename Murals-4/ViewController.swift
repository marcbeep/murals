//
//  ViewController.swift
//  Murals-4
//
//  Created by Marc Beepath on 12/12/2022.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var murals:muralList? = nil
    var info = ""
    
    func updateTheTable() {
        theTable.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return murals?.newbrighton_murals.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "theCell", for: indexPath)
            var content = UIListContentConfiguration.subtitleCell()
            content.text = murals?.newbrighton_murals[indexPath.row].title ?? "Title Unavailable"
            content.secondaryText = murals?.newbrighton_murals[indexPath.row].artist ?? "Artist Unavailable"
            cell.contentConfiguration = content
            return cell
    }
    
    @IBOutlet weak var theTable: UITableView!
    
    override func viewDidLoad() {
      super.viewDidLoad()
                     
      if let url = URL(string: "https://cgi.csc.liv.ac.uk/~phil/Teaching/COMP228/nbm/data2.php?class=newbrighton_murals") {
          let session = URLSession.shared
            session.dataTask(with: url) { (data, response, err) in
              guard let jsonData = data else {
                  return
              }
              do {
                  let decoder = JSONDecoder()
                  let reportList = try decoder.decode(muralList.self, from: jsonData)
                  self.murals = reportList
                  DispatchQueue.main.async {
                      self.updateTheTable()
                  }
              } catch let jsonErr {
                  print("Error decoding JSON", jsonErr)
              }
          }.resume()
       }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetail"{
            let viewController = segue.destination as! InfoViewController
            
            if let indexPath = self.theTable.indexPathForSelectedRow {
                viewController.info = murals?.newbrighton_murals[indexPath.row].info ?? "Info Unavailable"
            }
        }
    }

}

