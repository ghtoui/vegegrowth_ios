//
//  GrowthManageViewModel.swift
//  vegegrowth_ios
//
//  Created by toui on 2023/06/11.
//

import Foundation
import Charts
import RxSwift
import RxCocoa

class GrowthManageViewModel: BaseManageViewModel {
    
    private var browse = browseClass()
    private var isTransformed: Bool = false
    
    // 画像からbase64円コーディングする時に排他非同期処理を実装するためのもの
    private let imgEncodingQueue = DispatchQueue(label: "imgEncodingQueue")
    
    override init() {
        super.init()
        
        editMemoButtonTapped
            .subscribe(onNext: { [weak self] in
                self?.moveEditMemoView.accept(())
                self?.transformData()
            })
            .disposed(by: disposeBag)
    }
    
    override func getDatas() -> [VegeLengthObject] {
        let datas = detailVege.getUserDetailVegeList()
        guard !datas.isEmpty else {
            isHiddenLabelRelay.accept(false)
            return []
        }
        return datas
    }
    
    // 非同期で処理する
    // 画像をbase64に変換する
    private func asyncEncodeBase64(imgList: [UIImage?]) -> Observable<[String?]> {
        return Observable.create { observer in
            // 排他制御を開始
            self.imgEncodingQueue.sync {
                print(self.isTransformed)
                guard !self.isTransformed else {
                    // 処理中の場合は終了
                    observer.onCompleted()
                    return
                }
                self.isTransformed = true
                // スケジューラー
                // DispatchQueue.global().asyncをすると非同期処理ができる
                // main.asyncだと非同期処理中にUI更新ができない？
                DispatchQueue.global().async {
                    self.isTransformed = true
                    var base64List: [String?] = []
                    var i = 0
                    print(self.isTransformed)
                    for img in imgList {
                        print(i)
                        i += 1
                        if let imageData = img!.jpegData(compressionQuality: 1) {
                            let base64String = imageData.base64EncodedString()
                            base64List.append(base64String)
                        } else {
                            base64List.append(nil)
                        }
                    }
                    // 排他制御を終了
                    self.imgEncodingQueue.sync {
                        self.isTransformed = false
                        print(self.isTransformed)
                    }
                    observer.onNext(base64List)
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
    
    // 画像のリストをbase64リストに変換す
    private func imgToBase64(imgList: [UIImage?]) {
        asyncEncodeBase64(imgList: imgList)
            .subscribe(onNext: { result in
                print("ok")
            }, onError: { error in
                print("error")
            })
            .disposed(by: disposeBag)
        print("--------")
    }
    
    // 画像からbase64に変換する処理が、遅いのでどうにかしないといけない
    private func transformData() {
        let detailDataList = getDatas()
        let imgDataList: [UIImage?] = slideShow.getImgData()
        var x: [Double] = []
        var date: [String] = []
        var memoText: [String] = []
        var vegeLength: [Double] = []
        var base64EncodedImage: [String?] = []
        
        imgToBase64(imgList: imgDataList)
        for item in detailDataList {
            x.append(item.x)
            date.append(item.date)
            memoText.append(item.memoText)
            vegeLength.append(item.vegeLength)
        }
        // ここが遅い
        //        for img in imgDataList {
        //            base64EncodedImage.append(imgToBase64(img: img!))
        //        }
        //        let data: BrowseData = BrowseData(name: vegeName, date: date, vegeLength: vegeLength, x: x, memoText: memoText, base64EncodedImage: base64EncodedImage)
    }
}
