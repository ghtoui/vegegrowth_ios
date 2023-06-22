//
//  GrowthController.swift
//  vegegrowth_ios
//
//  Created by toui on 2023/05/15.
//

import UIKit
import RxSwift
import RxCocoa

class GrowthRegisterViewController: UIViewController {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var moveToManagerButton: UIBarButtonItem!
    @IBOutlet weak var takePicButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    private var vegeText :String!
    private let viewModel: GrowthRegisterViewModelType = GrowthRegisterViewModel()
    private let disposeBag = DisposeBag()
    
    // クラス
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        viewModel.inputs.isRegisterButton.accept(false)
        
        takePicButton.rx.tap
            .flatMapLatest { [weak self] _ in
                return UIImagePickerController.rx.createWithParent(self) { picker in
                    picker.sourceType = .camera
                    picker.allowsEditing = false
                }
                .flatMap { $0.rx.didFinishPickingMediaWithInfo }
                .take(1)
            }
            .map { info in
                return info[.originalImage] as? UIImage
            }
            .bind(to: imgView.rx.image)
            .disposed(by: disposeBag)
    
        registerButton.isHidden = true
        bind()
    }

    private func bind() {
        
        takePicButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)

        // 登録ボタンの表示切り替え
        viewModel.outputs.isPicTake
            .drive(onNext: { [weak self] isPic in
                if isPic {
                    self?.registerButton.isHidden = false
                    print(false)
                } else {
                    self?.registerButton.isHidden = true
                    print(true)
                }
            })
            .disposed(by: disposeBag)
        
        // 写真撮影ボタンを押した時の処理
        takePicButton.rx.tap
            .bind(to: viewModel.inputs.takePicButtonTapped)
            .disposed(by: disposeBag)
        
//        viewModel.outputs.cameraAlert
//            .subscribe(onNext: { [weak self] in
//                self?.takeButtonTapped()
//            })
//            .disposed(by: disposeBag)
        
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
    
    // 画面遷移してくる時用
    // 本当はinitでできると良いが...
    public func setVegeText(vegeText: String) {
        print(vegeText)
        // タイトル変更(タップしたラベルを反映する)
        // navigationcontrollerを使っている
        navigationItem.title = vegeText
        viewModel.inputs.vegeText.accept(vegeText)
    }

    // 撮影処理
//    private func takeButtonTapped() {
//        if UIImagePickerController.isSourceTypeAvailable(.camera) {
//            let image_picker = UIImagePickerController()
//            image_picker.sourceType = .camera
//            image_picker.delegate = self
//            self.present(image_picker, animated: true, completion: nil)
//        }
//    }
    
    // 写真撮影処理
    // takebutton_clickが押されたら処理する
    func imagePickerController(_ picker: UIImagePickerController,
                             didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
//        let take_img = img_class.take_img(picker, didFinishPickingMediaWithInfo: info)
//        imgview.image = take_img
        picker.dismiss(animated: true)

        guard let img = info[.originalImage] as? UIImage else {
            print("画像が見つかりませんでした")
            return
        }
        // 撮った写真を保存する
//        vege_text_list = get_vege_text_list(vege_id: vege_id)
//        let num = vege_text_list.count
//        file_name = self.vege_id + "_" + String(num)
//        print(file_name)
        // 画像の回転を直す
//        fix_rotateimg = fix_rotate(img: img)!
//        vege_text_list = get_vege_text_list(vege_id: vege_id)
//        print(vege_text_list)
//        registerButton.isHidden = false
    }
    
    // 野菜の大きさを入力する
    // 数字のみ受け付けるように
    private func registerVegeMeasure() {
        var textfield = UITextField()
        
        let alert = UIAlertController(title: "撮影した野菜の大きさを入力してください",
                                      message: "",
                                      preferredStyle: .alert)

        // 登録処理
        let register_action = UIAlertAction(title: "登録",style: .default) { (action) in
//            self.graph_class.add_vege_length(length: Double(textfield.text!)!)
//            let take_img: UIImage = self.img_class.get_takeimg()
//            let file_name = self.img_class.get_filename()
            // 撮影した画像を保存
//            self.img_class.save_img(file_name: file_name, img: take_img)
            // 登録したら、ボタンを消す
            self.registerButton.isHidden = true
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
