//
//  ViewController.swift
//  Learn_RxSwift
//
//  Created by Thân Văn Thanh on 03/08/2021.
//

import UIKit
import RxCocoa
import RxSwift

struct Product {
    let imageName : String
    let title : String
}

struct ProductViewModel {
    var items = PublishSubject<[Product]>()
    
    func fetchITems() {
        let products = [
            Product(imageName: "house", title: "Home"),
            Product(imageName: "gear", title: "Settings"),
            Product(imageName: "person.circle", title: "Profile"),
            Product(imageName: "airplane", title: "flights"),
            Product(imageName: "bell", title: "Activity")
        ]
        items.onNext(products)
        items.onCompleted()
    }
}

class ViewController: UIViewController {
    
    private let tableView : UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    private var viewModel = ProductViewModel()
    private var bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.frame = view.bounds
        bindTableData()
        // Do any additional setup after loading the view.
    }
    func bindTableData() {
        //Bind items to table
        viewModel.items.bind(to: tableView.rx.items(cellIdentifier: "cell", cellType: UITableViewCell.self)){row , model , cell in
            cell.textLabel?.text = model.title
            cell.imageView?.image = UIImage(systemName: model.imageName)
        }.disposed(by: bag)
        
        //bind a modle selected handler
        tableView.rx.modelSelected(Product.self).bind { product in
            print(product.title)
        }.disposed(by: bag)
        
        // fetch items
        viewModel.fetchITems()
    }
    
}

