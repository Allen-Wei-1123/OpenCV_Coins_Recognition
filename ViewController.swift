//
//  ViewController.swift
//  Coins
//
//  Created by Allen on 2019/3/28.
//  Copyright © 2019年 Allen. All rights reserved.
//

import UIKit
import CoreML
import Vision
class ViewController: UIViewController,UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    var imagesupload : UIImageView = {
        var imageviews = UIImageView()
        imageviews.translatesAutoresizingMaskIntoConstraints = false
        //imageviews.image = UIImage(named: "kobe.jpg")
        return imageviews
    }()
    
    var imagesupload2 : UIImageView = {
        var imageviews = UIImageView()
        imageviews.translatesAutoresizingMaskIntoConstraints = false
        //imageviews.image = UIImage(named: "kobe.jpg")
        return imageviews
    }()
    
    var imagesupload3 : UIImageView = {
        var imageviews = UIImageView()
        imageviews.translatesAutoresizingMaskIntoConstraints = false
        //imageviews.image = UIImage(named: "kobe.jpg")
        return imageviews
    }()
    
    var openImgLibrary: UIButton = {
        var uibuttons = UIButton();
        uibuttons.translatesAutoresizingMaskIntoConstraints = false
        uibuttons.setTitle("Click To Open Image Library", for: .normal)
        uibuttons.setTitleColor(.blue, for: .normal)
        uibuttons.addTarget(self, action: #selector(openimglibrary), for: .touchUpInside)
        return uibuttons
    }()
    
    var openImgTBL: UIButton = {
        var uibuttons = UIButton();
        uibuttons.translatesAutoresizingMaskIntoConstraints = false
        uibuttons.setTitle(">", for: .normal)
        uibuttons.setTitleColor(.blue, for: .normal)
        uibuttons.addTarget(self, action: #selector(GoToTBLView), for: .touchUpInside)
        return uibuttons
    }()
    
    var totalLabel : UILabel={
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    @objc func openimglibrary(){
        var pkcrviewUI = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary)
        {
            pkcrviewUI.sourceType = UIImagePickerController.SourceType.photoLibrary
            pkcrviewUI.allowsEditing = true
            pkcrviewUI.delegate = self
            [self .present(pkcrviewUI, animated: true , completion: nil)]
        }
    }
    
    @objc func GoToTBLView(){
        let newviewcntrl:DistributeCoinsViewController = DistributeCoinsViewController()
        newviewcntrl.newarray = temparray
        newviewcntrl.valuearray = valuearray
        self.present(newviewcntrl, animated: true, completion: nil)
    }
    
    func setup(){
        view.addSubview(imagesupload)
        //imagesupload.image = customimage
        imagesupload.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imagesupload.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        imagesupload.heightAnchor.constraint(equalToConstant: 400).isActive = true
        imagesupload.widthAnchor.constraint(equalToConstant: 350).isActive = true
        
        view.addSubview(totalLabel)
        totalLabel.topAnchor.constraint(equalTo: imagesupload.bottomAnchor, constant: 10).isActive = true
        totalLabel.rightAnchor.constraint(equalTo: imagesupload.rightAnchor).isActive = true
        totalLabel.leftAnchor.constraint(equalTo: imagesupload.leftAnchor).isActive = true
        totalLabel.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
//        view.addSubview(openImgLibrary)
//        openImgLibrary.heightAnchor.constraint(equalToConstant: 400).isActive = true
//        openImgLibrary.widthAnchor.constraint(equalToConstant: 350).isActive = true
//        openImgLibrary.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        openImgLibrary.bottomAnchor.constraint(equalTo: imagesupload.topAnchor, constant: 120).isActive = true
        
        
        view.addSubview(openImgTBL)
        openImgTBL.topAnchor.constraint(equalTo: totalLabel.bottomAnchor, constant: 10).isActive = true
        openImgTBL.rightAnchor.constraint(equalTo: imagesupload.rightAnchor).isActive = true
        openImgTBL.leftAnchor.constraint(equalTo: imagesupload.leftAnchor).isActive = true
        openImgTBL.heightAnchor.constraint(equalToConstant: 70).isActive = true
    }
    
    func myResultsMethod(request: VNRequest, error: Error?) {
        guard let results = request.results as? [VNClassificationObservation]
            else { fatalError("huh") }
        for classification in results {
            print(classification.identifier, // the scene label
                classification.confidence)
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imagesupload.image = pickedImage
           
            
        }
        //imagesupload.image = UIImage(named: "eightcoins11.jpg");
        dismiss(animated: true, completion: nil)
        
        
    }
    
    struct passoninfos {
        var imgviews : UIImageView!
        var value : String!
    }
    
    
    
    var temparray : NSMutableArray = []
    var valuearray = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(OpenCVWrapper.opencvversionstring())
        let image = UIImage(named: "coins6_11.jpg")
        
       //let newarray : NSMutableArray = OpenCVWrapper.backgroundsubtraction(image, image)
        let newarray : NSMutableArray = OpenCVWrapper.getCircles(image)
        //imagesupload.image = OpenCVWrapper.getGaussianImage(image) as! UIImage
        temparray = newarray
        setup()
        //imagesupload.image = newarray[newarray.count-1] as! UIImage;
        var sum : Double =  0;
                // let i = 0;
        let imgclassifier = ImageClassifier();
                let sizes = newarray.count
                for i in 0...newarray.count-2{
                    guard let model = try? VNCoreMLModel(for: imgclassifier.model) else{
                        fatalError()
                    }
                    let request = VNCoreMLRequest(model: model){[weak self] request,error in
                        guard let results = request.results as? [VNClassificationObservation],
                            let topresult = results.first
                            else{
                                fatalError()
                        }
                        DispatchQueue.main.async{ [weak self] in
                            print(topresult.identifier);
                            if(topresult.identifier == "Toonie"){
                                sum = sum+2;
                                self?.valuearray.append("Toonie")
                            }else if (topresult.identifier == "Loonie"){
                                sum = sum + 1;
                               self?.valuearray.append("Loonie")
                            }else if(topresult.identifier == "tencents"){
                                sum = sum + 0.1;
                            }else if(topresult.identifier == "fivecents"){
                                sum = sum + 0.05;
                            }else if (topresult.identifier == "quarter"){
                                sum = sum + 0.25;
                            }
                            print("total is ",sum);
                            self?.totalLabel.text = "$\(sum)";
                        }
                        
                    }

                    guard let ciimage = CIImage(image:newarray[i] as! UIImage!)else{
                        fatalError()
                    }

                    let handler = VNImageRequestHandler(ciImage: ciimage)
                    DispatchQueue.global().async {
                        do{
                            try handler.perform([request])
                            //self.valuearray.append("")
                        }catch{
                            print(error)
                        }

                    }
                }
        imagesupload.image = newarray[sizes-1] as! UIImage
        }
////
}


