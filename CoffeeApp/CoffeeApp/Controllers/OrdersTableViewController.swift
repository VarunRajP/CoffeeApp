//
//  OrdersTableViewController.swift
//  CoffeeApp
//
//  Created by Raj.P, Varun (Cognizant) on 08/07/24.
//

import UIKit

class OrdersTableViewController: UITableViewController, AddOrderDelegate {
    
    func didSave(controller: UIViewController, order: Order) {
        controller.dismiss(animated: true)

        let order = OrderViewModel(order: order)
        self.ordersListViewModel.ordersViewModel.append(order)
        self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
    }
    
    func didClose(controller: UIViewController) {
        controller.dismiss(animated: true)
    }
    

    var ordersListViewModel = OrderListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        populateOrders()
    }
    
    func populateOrders() {
        WebService().load(resource: Order.all) { [weak self] result in
            switch result {
            case .success(let orders):
                self?.ordersListViewModel.ordersViewModel = orders.map(OrderViewModel.init)
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let failure):
                print(failure)
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.ordersListViewModel.ordersViewModel.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let vm = ordersListViewModel.orderViewModel(at: indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderTableViewCell", for: indexPath)
        cell.textLabel?.text = vm.type
        cell.detailTextLabel?.text = vm.size
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let addOffeeVc = (segue.destination as! UINavigationController).viewControllers.first as! AddOrderNewViewController
        addOffeeVc.delegate = self
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
