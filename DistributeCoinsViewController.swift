//
//  DistributeCoinsViewController.swift
//  Coins
//
//  Created by Allen on 2019/4/12.
//  Copyright © 2019 Allen. All rights reserved.
//

import UIKit

class DistributeCoinsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newarray.count-1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        customtableview.register(tblviewcell1.self, forCellReuseIdentifier: "tblcell1")
        let cell = customtableview.dequeueReusableCell(withIdentifier: "tblcell1", for: indexPath) as! tblviewcell1
        cell.imgview.image = newarray[indexPath.row] as! UIImage
        if indexPath.row < valuearray.count{
            cell.infos.text = "\(indexPath.row). \(valuearray[indexPath.row])"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    

    
    func setup(){
        view.addSubview(customtableview)
        customtableview.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        customtableview.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        customtableview.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        customtableview.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        customtableview.delegate = self
        customtableview.dataSource = self
    }
    
    var newarray : NSMutableArray = [];
    var valuearray = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        print("ewarray count is \(newarray.count)")
        
        //DistributeCoinsViewController.init(nibName: "distributecoins", bundle: nil);
        
        // Do any additional setup after loading the view.
    }
    
    var customtableview:UITableView = {
        var tblview = UITableView()
        tblview.translatesAutoresizingMaskIntoConstraints = false
        return tblview
    }()

}

class tblviewcell1 : UITableViewCell{
    
    var imgview : UIImageView = {
        var imgview = UIImageView()
        imgview.translatesAutoresizingMaskIntoConstraints = false
        return imgview
    }()
    
    var infos:UILabel = {
        var labe = UILabel()
        labe.translatesAutoresizingMaskIntoConstraints = false
        return labe
    }()
    
    func setup(){
        self.addSubview(imgview)
        imgview.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        imgview.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        imgview.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        imgview.widthAnchor.constraint(equalToConstant: 150).isActive = true
        
        self.addSubview(infos)
        infos.leftAnchor.constraint(equalTo: imgview.rightAnchor, constant: 20).isActive = true
        infos.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        infos.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        infos.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        infos.textAlignment = .center
        infos.font = UIFont.systemFont(ofSize: 25)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
}
