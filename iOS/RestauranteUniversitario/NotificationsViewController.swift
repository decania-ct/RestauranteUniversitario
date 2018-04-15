//
//  NotificationsViewController.swift
//  RestauranteUniversitario
//
//  Created by Felipe Podolan Oliveira on 02/08/17.
//  Copyright © 2017 Felipe Podolan Oliveira. All rights reserved.
//

import UIKit
import Toast_Swift

class NotificationsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    @IBOutlet weak var buttonSend: UIButton!
    @IBOutlet weak var notificationsTable: UITableView!
    @IBOutlet weak var textID: UITextField!
    @IBOutlet weak var switchId: UISwitch!
    @IBOutlet var scrollView: UIScrollView!
    
    var ids = [String]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        buttonSend.addTarget(self, action: #selector(self.sendFunction), for: .touchUpInside)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActive), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        didBecomeActive()
    }
    
    func didBecomeActive() {
        navigationController?.setNavigationBarHidden(false, animated: false)
        let bar:UINavigationBar! =  self.navigationController?.navigationBar
        self.title = ""
        bar?.backItem?.title = "Navigation Bar Back Button Title".localized
        bar?.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        bar?.shadowImage = UIImage()
        bar?.tintColor = AppUtility.hexStringToUIColor(hex: "#029100")
        bar?.backgroundColor = UIColor(white: 1, alpha: 0.0)
        
        self.switchId.onTintColor = AppUtility.hexStringToUIColor(hex: "#029100")
        self.switchId.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        
        self.notificationsTable.dataSource = self
        self.notificationsTable.delegate = self
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(NotificationsViewController.dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        
        
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.title = "Navigation Bar Back Button Title".localized
    }
    
    func sendFunction() {
        view.endEditing(true)
        if textID.text != "" {
            ids.append(textID.text!)
            self.notificationsTable.reloadData()
        }
        else {
            self.scrollView.makeToast("Invalid Id Message".localized)
        }
        print(ids)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ids.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationsTableViewCell", for: indexPath) as? NotificationsTableViewCell  else {
            fatalError("The dequeued cell is not an instance of NotificationsTableViewCell.")
        }
        cell.identityLabel.text = ids[indexPath.row]
        cell.deleteIcon.tag = indexPath.row
        cell.deleteIcon.addTarget(self, action: #selector(imageTapped(_:)), for: .touchUpInside)
        return cell
    }
    
    func imageTapped(_ sender: UIButton) {
        print(sender.tag)
        ids.remove(at: sender.tag)
        self.notificationsTable.reloadData()
    }

}
