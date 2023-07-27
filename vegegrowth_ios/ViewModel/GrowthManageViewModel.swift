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
    private var base64StringList: [String?] = []
    
    // 画像からbase64円コーディングする時に排他非同期処理を実装するためのもの
    private let imgEncodingQueue = DispatchQueue(label: "imgEncodingQueue", attributes: .concurrent)
    
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
            // 排他制御で非同期処理を開始
            self.imgEncodingQueue.async {
                print(self.isTransformed)
                guard !self.isTransformed else {
                    // 処理中の場合は終了
                    observer.onCompleted()
                    return
                }
                self.isTransformed = true
                self.isTransformed = true
                var base64List: [String?] = []
                var i = 0
                for img in imgList {
                    print(i)
                    i += 1
                    if let imageData = img!.jpegData(compressionQuality: 1) {
                        let base64String = imageData.base64EncodedString()
                        base64List.append(base64String)
//                        base64List.append("\(i)")
                    } else {
                        base64List.append(nil)
                    }
                }
                // 排他制御を終了
                self.imgEncodingQueue.async {
                    self.isTransformed = false
                }
                observer.onNext(base64List)
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    // 画像のリストをbase64リストに変換する
    private func imgToBase64() {
        let imgDataList: [UIImage?] = slideShow.getImgData()
        asyncEncodeBase64(imgList: imgDataList)
            .subscribe(onNext: { [weak self] result in
                self?.base64StringList = result
                self?.transformData()
            })
            .disposed(by: disposeBag)
    }
    
    // 画像からbase64に変換する処理が、遅いのでどうにかしないといけない
    private func transformData() {
        let imgDataList: [UIImage?] = slideShow.getImgData()
        let detailDataList = getDatas()
        var x: [Double] = []
        var date: [String] = []
        var memoText: [String] = []
        var vegeLength: [Double] = []
        var base64EncodedImage: [String?] = []
        
        // 空のデータを入れる
        for _ in imgDataList {
            base64EncodedImage.append(nil)
        }
        
        for item in detailDataList {
            x.append(item.x)
            date.append(item.date)
            memoText.append(item.memoText)
            vegeLength.append(item.vegeLength)
        }
        
        let data: BrowseData = BrowseData(name: vegeName, date: date, vegeLength: vegeLength, x: x, memoText: memoText, base64EncodedImage: base64EncodedImage)
        browse._sendData(model: data, imgList: imgDataList)
            .subscribe(onNext: { bool in
            })
            .disposed(by: disposeBag)
    }
}
