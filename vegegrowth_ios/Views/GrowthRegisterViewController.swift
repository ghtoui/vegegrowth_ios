//
//  GrowthController.swift
//  vegegrowth_ios
//
//  Created by toui on 2023/05/15.
//

import UIKit
import RxSwift
import RxCocoa

class GrowthRegisterViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var moveToManagerButton: UIBarButtonItem!
    @IBOutlet weak var takePicButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    private var vegeText: String!
    private let viewModel: GrowthRegisterViewModelType = GrowthRegisterViewModel()
    private let disposeBag = DisposeBag()
    
    // クラス
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        registerButton.isHidden = true
    
        bind()
        navigationItemSettings()
        viewModel.inputs.vegeText.accept(vegeText)
    }
    
    init?(coder: NSCoder, vegeText: String) {
        super.init(coder: coder)
        self.vegeText = vegeText
        // タイトル変更(タップしたラベルを反映する)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func bind() {
        viewModel.inputs.isRegisterButton.accept(false)
        
//        takePicButton.rx.tap
//            .flatMapLatest { [weak self] _ in
//                return UIImagePickerController.rx.createWithParent(self) { picker in
//                    picker.sourceType = .camera
//                    picker.allowsEditing = false
//                }
//                .flatMap { $0.rx.didFinishPickingMediaWithInfo }
//                .take(1)
//            }
//            .map { info in
//                return info[.originalImage] as? UIImage
//            }
//            .bind(to: imgView.rx.image)
//            .disposed(by: disposeBag)
        
        //        takePicButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        moveToManagerButton.rx.tap
            .subscribe(onNext: {[weak self] _ in
                if let vegeText = self?.vegeText, !vegeText.isEmpty {
                    self?.goTo(vegeText: vegeText)
                }
            })
            .disposed(by: disposeBag)
        

        // 登録ボタンの表示切り替え
        viewModel.outputs.isPicTake
            .drive(onNext: { [weak self] isPic in
                if isPic {
                    self?.registerButton.isHidden = false
                } else {
                    self?.registerButton.isHidden = true
                }
            })
            .disposed(by: disposeBag)
        
        // 写真撮影ボタンを押した時の処理
        takePicButton.rx.tap
            .bind(to: viewModel.inputs.takePicButtonTapped)
            .disposed(by: disposeBag)
        
        viewModel.outputs.cameraAlert
            .subscribe(onNext: { [weak self] in
                self?.takeButtonTapped()
            })
            .disposed(by: disposeBag)
        
        // 登録ボタンを押した時の処理
        registerButton.rx.tap
            .bind(to: viewModel.inputs.registerButtonTapped)
            .disposed(by: disposeBag)
        
        // 登録ウィンドウを表示する
        viewModel.outputs.showAlert
            .subscribe(onNext: { [weak self] in
                self?.registerVegeMeasure()
            })
            .disposed(by: disposeBag)
    }
    

    // 撮影処理
    private func takeButtonTapped() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let image_picker = UIImagePickerController()
            image_picker.sourceType = .camera
            image_picker.delegate = self
            self.present(image_picker, animated: true, completion: nil)
        }
    }
    
    // 写真撮影処理
    // takebutton_clickが押されたら処理する
    func imagePickerController(_ picker: UIImagePickerController,
                             didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        picker.dismiss(animated: true)
        guard let takeImg = info[.originalImage] as? UIImage else {
            print("画像が見つかりませんでした")
            return
        }
        
        imgView.image = takeImg
        registerButton.isHidden = false

        // 撮った写真を保存する
//        vege_text_list = get_vege_text_list(vege_id: vege_id)
//        let num = vege_text_list.count
//        file_name = self.vege_id + "_" + String(num)
//        print(file_name)
        // 画像の回転を直す
//        fix_rotateimg = fix_rotate(img: img)!
//        vege_text_list = get_vege_text_list(vege_id: vege_id)
//        print(vege_text_list)
    }
    
    // 野菜の大きさを入力する
    // 数字のみ受け付けるように
    private func registerVegeMeasure() {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "撮影した野菜の大きさを入力してください",
                                      message: "",
                                      preferredStyle: .alert)

        // 登録処理
        let registerAction = UIAlertAction(title: "登録",style: .default) { (action) in
//            self.graph_class.add_vege_length(length: Double(textfield.text!)!)
//            let take_img: UIImage = self.img_class.get_takeimg()
//            let file_name = self.img_class.get_filename()
            // 撮影した画像を保存
//            self.img_class.save_img(file_name: file_name, img: take_img)
            guard let vegeLength: Double = Double(textField.text!) else {
                return
            }
            
            guard let img: UIImage = self.imgView.image else {
                return
            }
            
            self.viewModel.inputs.saveVegeData(length: vegeLength, img: img)
            // 登録したら、ボタンを消す
            self.registerButton.isHidden = true
        }
        // キャンセル処理, 何もしない
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (action) in
        }
    
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "野菜の大きさを登録"
            textField = alertTextField
            textField.keyboardType = .decimalPad
        }
        alert.addAction(registerAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    private func goTo(vegeText: String) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let VC = storyBoard.instantiateViewController(identifier: "GrowthManagerView") { coder in
            return GrowthManageViewController(coder: coder, vegeText: vegeText)
        }
        navigationController?.pushViewController(VC, animated: true)
    }
    
    private func navigationItemSettings() {
        // ボタンのサイズ
        let buttonFontSize: CGFloat = 20
        
        // titleの設定
        navigationItem.title = vegeText
        
        // 右ボタンの設定
        if let rightButton = navigationItem.rightBarButtonItem {
            let attributes: [NSAttributedString.Key: Any] = [
                // フォントサイズを設定
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: buttonFontSize)             ]
            rightButton.setTitleTextAttributes(attributes, for: .normal)
        }
        
        // バックボタンを矢印だけにする
        navigationItem.backButtonDisplayMode = .minimal
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

func dismissViewController(_ viewController: UIViewController, animated: Bool) {
    if viewController.isBeingDismissed || viewController.isBeingPresented {
        DispatchQueue.main.async {
            dismissViewController(viewController, animated: animated)
        }

        return
    }

    if viewController.presentingViewController != nil {
        viewController.dismiss(animated: animated, completion: nil)
    }
}

extension Reactive where Base: UIImagePickerController {
    static func createWithParent(_ parent: UIViewController?, animated: Bool = true, configureImagePicker: @escaping (UIImagePickerController) throws -> Void = { x in }) -> Observable<UIImagePickerController> {
        return Observable.create { [weak parent] observer in
            let imagePicker = UIImagePickerController()
            let dismissDisposable = imagePicker.rx
                .didCancel
                .subscribe(onNext: { [weak imagePicker] _ in
                    guard let imagePicker = imagePicker else {
                        return
                    }
                    dismissViewController(imagePicker, animated: animated)
                })
            
            do {
                try configureImagePicker(imagePicker)
            }
            catch let error {
                observer.on(.error(error))
                return Disposables.create()
            }

            guard let parent = parent else {
                observer.on(.completed)
                return Disposables.create()
            }

            parent.present(imagePicker, animated: animated, completion: nil)
            observer.on(.next(imagePicker))
            
            return Disposables.create(dismissDisposable, Disposables.create {
                    dismissViewController(imagePicker, animated: animated)
                })
        }
    }
    
}

extension Reactive where Base: UIImagePickerController {
    /**
     Reactive wrapper for `delegate` message.
     */
    public var didFinishPickingMediaWithInfo: Observable<[UIImagePickerController.InfoKey : AnyObject]> {
        return delegate
            .methodInvoked(#selector(UIImagePickerControllerDelegate.imagePickerController(_:didFinishPickingMediaWithInfo:)))
            .map({ (a) in
                return try castOrThrow(Dictionary<UIImagePickerController.InfoKey, AnyObject>.self, a[1])
            })
    }

    /**
     Reactive wrapper for `delegate` message.
     */
    public var didCancel: Observable<()> {
        return delegate
            .methodInvoked(#selector(UIImagePickerControllerDelegate.imagePickerControllerDidCancel(_:)))
            .map {_ in () }
    }
    
}
    
private func castOrThrow<T>(_ resultType: T.Type, _ object: Any) throws -> T {
    guard let returnValue = object as? T else {
        throw RxCocoaError.castingError(object: object, targetType: resultType)
    }

    return returnValue
}
