//
//  ViewController.swift
//  Example
//
//  Created by 刘业臻 on 16/4/23.
//  Copyright © 2016年 luiyezheng. All rights reserved.
//

import UIKit
import StickerTextView

class ViewController: UIViewController {
    var colorsArray = [UIColor.whiteColor(), UIColor.blackColor(), UIColor.yellowColor()]
    var fontNamesArray = ["AcademyEngravedLetPlain", "AlNile-Bold", "Chalkduster"]
    var textAlphaArray = [0.3, 0.6, 1.0]

    @IBOutlet var stickerView: stickerImageView!
    
    @IBAction func onRefreshColor(sender: UIBarButtonItem) {
        let index = arc4random_uniform(3)
        let color = colorsArray[Int(index)]
        
        stickerView.textColor = color
    }
    
    
    @IBAction func onRefreshFont(sender: UIBarButtonItem) {
        let index = arc4random_uniform(3)
        let fontName = fontNamesArray[Int(index)]
        
        stickerView.fontName = fontName
    }
    
    
    @IBAction func onRefreshTextAlpha(sender: UIBarButtonItem) {
        let index = arc4random_uniform(3)
        let textAlpha = textAlphaArray[Int(index)]
        
        stickerView.textAlpha = CGFloat(textAlpha)
        
    }
    
    
    @IBAction func onAddLabel(sender: UIBarButtonItem) {
        //Add the label
        stickerView.addLabel()
        
        //Modify the Label
        stickerView.textColor = UIColor.whiteColor()
        stickerView.textAlpha = 1
        
    }
    
    @IBAction func onSaveImage(sender: UIBarButtonItem) {
        //render text on Image and save the Image
        let image = stickerView.renderTextOnView(stickerView)
        UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)

        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //This is optional. Not tested yet
        stickerView.limitImageViewToSuperView()
        stickerView.center = self.view.center
        stickerView.contentMode = .ScaleAspectFit
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

