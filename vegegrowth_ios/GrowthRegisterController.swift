//
//  GrowthController.swift
//  vegegrowth_ios
//
//  Created by toui on 2023/05/15.
//

import UIKit

class GrowthRegisterController: UIViewController,
                                UIImagePickerControllerDelegate,
                                UINavigationControllerDelegate {

    @IBOutlet weak var imgview: UIImageView!
    @IBOutlet weak var register_button: UIButton!
    
    public var vege_text :String!
    private var vege_id: String!
    
    // クラス
    private var img_class: ImgClass!
    private var graph_class : GraphClass!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // クラスの生成
        // 野菜の名前に紐づけられたユニークIDを取得する
        vege_id = vege_id_dict[vege_text]!
        
        img_class = ImgClass(vege_id: vege_id)
        graph_class = GraphClass(vege_id: vege_id)
        
        // vege_text_listの取得
        if UserDefaults.standard.object(forKey: vege_id) != nil {
            vege_text_list = UserDefaults.standard.object(forKey: vege_id) as! [String]
        }

        // タイトル変更(タップしたラベルを反映する)
        // navigationcontrollerを使っている
        navigationItem.title = vege_text
        register_button.isHidden = true
    }

    // 撮影ボタンが押された時の処理
    @IBAction func takebutton_click(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let image_picker = UIImagePickerController()
            image_picker.sourceType = .camera
            image_picker.delegate = self
            self.present(image_picker, animated: true, completion: nil)
        } else {
            print("カメラが無いです")
        }
    }
    
    // 写真撮影処理
    // takebutton_clickが押されたら処理する
    func imagePickerController(_ picker: UIImagePickerController,
                             didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        let take_img = img_class.take_img(picker, didFinishPickingMediaWithInfo: info)
        imgview.image = take_img
        register_button.isHidden = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "graphviewsegue" {
            if let destinationVC = segue.destination as? GrowthManageController {
                destinationVC.vege_text = vege_text
            }
        }
    }
    
    // 野菜の大きさを入力する
    // 数字のみ受け付けるように
    @IBAction func click_registerbutton(_ sender: Any) {
        var textfield = UITextField()
        
        let alert = UIAlertController(title: "撮影した野菜の大きさを入力してください",
                                      message: "",
                                      preferredStyle: .alert)

        // 登録処理
        let register_action = UIAlertAction(title: "登録",style: .default) { (action) in
            self.graph_class.add_vege_length(length: Double(textfield.text!)!)
            let take_img: UIImage = self.img_class.get_takeimg()
            let file_name = self.img_class.get_filename()
            // 撮影した画像を保存
            self.img_class.save_img(file_name: file_name, img: take_img)
            // 登録したら、ボタンを消す
            self.register_button.isHidden = true
        }
        // キャンセル処理, 何もしない
        let cancel_action = UIAlertAction(title: "キャンセル", style: .cancel) { (action) in
        }
    
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "野菜の大きさを登録"
            textfield = alertTextField
            textfield.keyboardType = .decimalPad
        }
        alert.addAction(register_action)
        alert.addAction(cancel_action)
        present(alert, animated: true, completion: nil)
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
