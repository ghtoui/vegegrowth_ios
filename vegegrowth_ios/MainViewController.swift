//
//  MainViewController.swift
//  vegegrowth_ios
//
//  Created by toui on 2023/05/18.
//

import UIKit

class MainViewController: UIViewController,
                          UITableViewDelegate,
                          UITableViewDataSource {
    
    @IBOutlet weak var vegetable: UITableView!
    
    var table_manager : TablemanagerClass = TablemanagerClass()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        vegetable.delegate = self
        vegetable.dataSource = self
    }
    
    @IBAction func vegeadd_click(_ sender: Any) {
        var textfield = UITextField()
        let alert = UIAlertController(title: "管理する野菜の名前を入力してください",
                                      message: "",
                                      preferredStyle: .alert)
        // 追加処理
        let add_action = UIAlertAction(title: "追加",style: .default) { (action) in
            self.table_manager.add_vege(vege_text: textfield.text!)
            self.vegetable.reloadData()
        }
        // キャンセル処理, 何もしない
        let cancel_action = UIAlertAction(title: "キャンセル", style: .cancel) { (action) in
        }
    
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "野菜の名前を入力"
            textfield = alertTextField
            
        }
        alert.addAction(add_action)
        alert.addAction(cancel_action)
        present(alert, animated: true, completion: nil)
    }
    
    // 要素数を数える
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vege_list.count
    }
    // テーブルのセルに表示する
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "vegecell_Identifier", for: indexPath)
        cell.textLabel?.text = vege_list[indexPath.row]
        return cell
    }
    
    // テーブルのセルを削除(UserDefaultからも削除する)
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            vege_list.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            table_manager.set_uservegelist()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "vegemanager_segue" {
            if let index_path = vegetable.indexPathForSelectedRow {
                let selected_text = vege_list[index_path.row]
                if let destinationVC = segue.destination as? GrowthRegisterController {
                    destinationVC.vege_text = selected_text
                }
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

}
