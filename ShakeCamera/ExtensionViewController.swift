//
//  ExtensionViewController.swift
//  ShakeCamera
//
//  Created by 三上大河 on 2017/04/20.
//  Copyright © 2017年 Gutty. All rights reserved.
//

import Photos

// デリゲート部分を拡張する
extension ViewController:AVCapturePhotoCaptureDelegate {
    // 映像をキャプチャする
    func capture(_ captureOutput: AVCapturePhotoOutput,
                 didFinishProcessingPhotoSampleBuffer photoSampleBuffer: CMSampleBuffer?,
                 previewPhotoSampleBuffer: CMSampleBuffer?,
                 resolvedSettings: AVCaptureResolvedPhotoSettings,
                 bracketSettings: AVCaptureBracketedStillImageSettings?,
                 error: Error?) {
        
        // バッファからjpegデータを取り出す
        let photoData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(
            forJPEGSampleBuffer: photoSampleBuffer!,
            previewPhotoSampleBuffer: previewPhotoSampleBuffer)
        //　photoDataがnilでないときUIImageに変換する
        if let data = photoData {
            if let stillImage = UIImage(data: data) {
                // アルバムに追加する
                UIImageWriteToSavedPhotosAlbum(stillImage, self, nil, nil)
            }
        }
    }
}
