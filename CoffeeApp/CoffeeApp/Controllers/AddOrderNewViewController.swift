//
//  AddOrderNewViewController.swift
//  CoffeeApp
//
//  Created by Raj.P, Varun (Cognizant) on 08/07/24.
//

import UIKit

protocol AddOrderDelegate {
    func didSave(controller: UIViewController, order: Order)
    func didClose(controller: UIViewController)
}

class AddOrderNewViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    
    private var segmented: UISegmentedControl!
    var delegate: AddOrderDelegate?
    
    var addOrderVM = AddCoffeOrderViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        // Do any additional setup after loading the view.
    }

    private func setUp() {
        segmented = UISegmentedControl(items: self.addOrderVM.size)
        segmented.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(segmented)
        
        self.segmented.topAnchor.constraint(equalTo: self.tableView.bottomAnchor, constant: 20).isActive = true
        self.segmented.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    }
    
    @IBAction func save() {
        let selectedSize = segmented.titleForSegment(at: segmented.selectedSegmentIndex)
        
        guard let indexpath = tableView.indexPathForSelectedRow else { return }
        
        self.addOrderVM.name = nameTF.text
        self.addOrderVM.email = emailTF.text
        self.addOrderVM.selectedSize = selectedSize
        self.addOrderVM.selectedType = addOrderVM.types[indexpath.row]
        
        WebService().load(resource: Order.createOrder(vm: addOrderVM)) { [self] result in
            switch result {
            case .success(let order):
                print(order)
                
                if let delegate = delegate, let order = order {
                    delegate.didSave(controller: self, order: order)
                }
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    @IBAction func goBack() {
        delegate?.didClose(controller: self)
    }
    
}

extension AddOrderNewViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addOrderVM.types.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddCoffeeOrderCell", for: indexPath)
        cell.textLabel?.text = addOrderVM.types[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
    }
}
