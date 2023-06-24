//
//  GrowthViewModel.swift
//  vegegrowth_ios
//
//  Created by toui on 2023/06/11.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit.UIImage

protocol GrowthRegisterViewModelInputs {
    var takePicButtonTapped: PublishRelay<Void> { get }
    var moveToManagerButtonTapped: PublishRelay<Void> { get }
    var registerButtonTapped: PublishRelay<Void> { get }
    var vegeText: BehaviorRelay<String> { get }
    var isRegisterButton: PublishRelay<Bool> { get }
}

protocol GrowthRegisterViewModelOutputs {
    var vegeId: PublishRelay<String> { get }
    var isPicTake: Driver<Bool> { get }
    var showAlert: PublishRelay<Void> { get }
    var cameraAlert: PublishRelay<Void> { get }
}

protocol GrowthRegisterViewModelType {
    var inputs: GrowthRegisterViewModelInputs { get }
    var outputs: GrowthRegisterViewModelOutputs { get }
}

class GrowthRegisterViewModel: GrowthRegisterViewModelType, GrowthRegisterViewModelInputs, GrowthRegisterViewModelOutputs {
    
    var inputs: GrowthRegisterViewModelInputs { return self }
    var outputs: GrowthRegisterViewModelOutputs { return self }
    
    // MARK: - inputs
    var takePicButtonTapped = PublishRelay<Void>()
    var moveToManagerButtonTapped = PublishRelay<Void>()
    var registerButtonTapped = PublishRelay<Void>()
    var vegeText = BehaviorRelay<String>(value: "")
    var isRegisterButton = PublishRelay<Bool>()
    
    // MARK: - outputs
    var vegeId = PublishRelay<String>()
    var isPicTake: Driver<Bool>
    var showAlert = PublishRelay<Void>()
    var cameraAlert = PublishRelay<Void>()
    
    private let vegeManager = VegeManagerClass()
    private let disposeBag = DisposeBag()
    private var imgClass: ImgClass!
    private var graphClass: GraphClass!
    private var vegeTextList: [String]!
    
    init() {
        isPicTake = isRegisterButton.asDriver(onErrorDriveWith: .empty())
        // vegeTextの値に基づいて、VegeIdが決まる
        // 野菜の名前に紐づけられたユニークId
        vegeText
            .compactMap { [weak self] vegeText in
                guard let vegeIdDict = self?.vegeManager.getVegeIdDict() else {
                    return nil
                }
                return vegeIdDict[vegeText]
            }
            .bind(to: vegeId)
            .disposed(by: disposeBag)

        
        // vegeIdが更新されたら、imgclassとgraphclassを生成する
        // vegeIdに対応したvegeTextListも持ってくる
        vegeId
            .subscribe(onNext: { [weak self] vegeId in
                self?.imgClass = ImgClass(vegeId: vegeId)
                self?.graphClass = GraphClass(vegeId: vegeId)
            })
            .disposed(by: disposeBag)
        
        // 登録ボタンが押されたことをViewに通知する
        registerButtonTapped
            .subscribe(onNext: { [weak self] in
                self?.showAlert.accept(())
            })
            .disposed(by: disposeBag)
        
        // 撮影ボタンが押されたことをViewに通知する
        takePicButtonTapped
            .subscribe(onNext: { [weak self] in
                self?.cameraAlert.accept(())
            })
            .disposed(by: disposeBag)
        
        
    }
}
