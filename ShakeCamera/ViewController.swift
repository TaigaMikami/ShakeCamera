//
//  ViewController.swift
//  ShakeCamera
//
//  Created by 三上大河 on 2017/04/20.
//  Copyright © 2017年 Gutty. All rights reserved.
//


import UIKit
import AVFoundation

class ViewController: UIViewController{
    // プレビュー用のビューとOutlet接続しておく
    @IBOutlet weak var previewView: UIView!
    // インスタンスの作成
    var session = AVCaptureSession()
    var photoOutput = AVCapturePhotoOutput()
    // 通知センターを作る
    let notification = NotificationCenter.default
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // セッション実行中ならば中断する
        if session.isRunning {
            return
        }
        // 入出力の設定
        setupInputOutput()
        // プレビューレイヤの設定
        setPreviewLayer()
        // セッション開始
        session.startRunning()
        // デバイスが回転したときに通知するイベントハンドラを設定する
        notification.addObserver(self,
                                 selector: #selector(self.changedDeviceOrientation(_:)),
                                 name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    // シャッターボタンで実行する
    @IBAction func takePhoto(_ sender: Any) {
        let captureSetting = AVCapturePhotoSettings()
        captureSetting.flashMode = .auto
        captureSetting.isAutoStillImageStabilizationEnabled = true
        captureSetting.isHighResolutionPhotoEnabled = false
        // キャプチャのイメージ処理はデリゲートに任せる
        photoOutput.capturePhoto(with: captureSetting, delegate: self)
    }
    
    // 入出力の設定
    func setupInputOutput(){
        //解像度の指定
        session.sessionPreset = AVCaptureSessionPresetPhoto
        
        // 入力の設定
        do {
            //デバイスの取得
            let device = AVCaptureDevice.defaultDevice(
                withDeviceType: AVCaptureDeviceType.builtInWideAngleCamera,
                mediaType: AVMediaTypeVideo,
                position: .back)
            
            // 入力元
            let input = try AVCaptureDeviceInput(device: device)
            if session.canAddInput(input){
                session.addInput(input)
            } else {
                print("セッションに入力を追加できなかった")
                return
            }
        } catch  let error as NSError {
            print("カメラがない \(error)")
            return
        }
        
        // 出力の設定
        if session.canAddOutput(photoOutput) {
            session.addOutput(photoOutput)
        } else {
            print("セッションに出力を追加できなかった")
            return
        }
    }
    
    // プレビューレイヤの設定
    func setPreviewLayer(){
        // プレビューレイヤを作る
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        guard let videoLayer = previewLayer else {
            print("プレビューレイヤを作れなかった")
            return
        }
        videoLayer.frame = view.bounds
        videoLayer.masksToBounds = true
        videoLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        // previewViewに追加する
        previewView.layer.addSublayer(videoLayer)
    }
    
    // デバイスの向きが変わったときに呼び出すメソッド
    func changedDeviceOrientation(_ notification :Notification) {
        // photoOutput.connectionの回転向きをデバイスと合わせる
        if let photoOutputConnection = self.photoOutput.connection(withMediaType: AVMediaTypeVideo) {
            switch UIDevice.current.orientation {
            case .portrait:
                photoOutputConnection.videoOrientation = .portrait
            case .portraitUpsideDown:
                photoOutputConnection.videoOrientation = .portraitUpsideDown
            case .landscapeLeft:
                photoOutputConnection.videoOrientation = .landscapeRight
            case .landscapeRight:
                photoOutputConnection.videoOrientation = .landscapeLeft
            default:
                break
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
