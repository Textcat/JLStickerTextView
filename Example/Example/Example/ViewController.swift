//
//  ViewController.swift
//  Example
//
//  Created by 刘业臻 on 16/4/23.
//  Copyright © 2016年 luiyezheng. All rights reserved.
//

import UIKit
import JLStickerTextView

class ViewController: UIViewController {
    var colorsArray = [UIColor.white(), UIColor.black(), UIColor.yellow()]
    var fontNamesArray = ["AcademyEngravedLetPlain", "AlNile-Bold", "Chalkduster"]
    var textAlphaArray = [0.3, 0.6, 1.0]
    var lineSpacings = [1,30,50]
    var shadowOffsets = [1.0, 10.0, 20.0]
    
    @IBOutlet var stickerView: JLStickerImageView!
    
    @IBAction func onRefreshColor(_ sender: UIBarButtonItem) {
        let index = arc4random_uniform(3)
        let color = colorsArray[Int(index)]
        
        stickerView.textColor = color
    }
    
    @IBAction func onRefreshLineSpacing(_ sender: UIBarButtonItem) {
        let index = arc4random_uniform(3)
        let lineSpacing = lineSpacings[Int(index)]
        
        stickerView.lineSpacing = CGFloat(lineSpacing)
    }
    
    
    @IBAction func onRefreshFont(_ sender: UIBarButtonItem) {
        let index = arc4random_uniform(3)
        let fontName = fontNamesArray[Int(index)]
        
        stickerView.fontName = fontName
    }
    
    
    @IBAction func onRefreshTextAlpha(_ sender: UIBarButtonItem) {
        let index = arc4random_uniform(3)
        let textAlpha = textAlphaArray[Int(index)]
        
        stickerView.textAlpha = CGFloat(textAlpha)
        
    }
    
    @IBAction func onAddLabel(_ sender: UIBarButtonItem) {
        //Add the label
        stickerView.addLabel()
        
        //Modify the Label
        stickerView.textColor = UIColor.white()
        stickerView.textAlpha = 1
        stickerView.currentlyEditingLabel.closeView!.image = UIImage(named: "cancel")
        stickerView.currentlyEditingLabel.rotateView?.image = UIImage(named: "rotate")
        stickerView.currentlyEditingLabel.border?.strokeColor = UIColor.white().cgColor
        
    }
    
    @IBAction func onRefreshShadow(_ sender: UIBarButtonItem) {
        let index = arc4random_uniform(3)
        let shadowOffset = shadowOffsets[Int(index)]
        
        stickerView.textShadowOffset = CGSize(width: CGFloat(shadowOffset), height: 10)
        stickerView.textShadowColor = UIColor.red()
    }
    
    
    @IBAction func onSaveImage(_ sender: UIBarButtonItem) {
        //render text on Image and save the Image
        let image = stickerView.renderTextOnView(stickerView)
        UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //This is optional. Not tested yet
        stickerView.limitImageViewToSuperView()
        stickerView.center = self.view.center
        stickerView.contentMode = .scaleAspectFit
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

