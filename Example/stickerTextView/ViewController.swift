//
//  ViewController.swift
//  stickerTextView
//
//  Created by 刘业臻 on 16/4/19.
//  Copyright © 2016年 luiyezheng. All rights reserved.
//

import UIKit

class ViewController: UIViewController, stickerLabelViewDelegate{

    @IBAction func onAddLabel(sender: UIBarButtonItem) {
        stickerView.addLabel()
        
        stickerView.textColor = UIColor.whiteColor()
        stickerView.textAlpha = 1
        
        
    }
    
    @IBAction func onSaveImage(sender: UIBarButtonItem) {
        let image = stickerView.renderTextOnView(stickerView)
        UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
        
    }
    @IBOutlet var stickerView: stickerImageView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        stickerView.limitImageViewToSuperView()
        stickerView.center = self.view.center
        stickerView.contentMode = .ScaleToFill
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

