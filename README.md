# OpenCV_Coins_Recognition
1. Set up buttons, label, and UIImageView
```
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
        
        view.addSubview(openImgLibrary)
        openImgLibrary.heightAnchor.constraint(equalToConstant: 400).isActive = true
        openImgLibrary.widthAnchor.constraint(equalToConstant: 350).isActive = true
        openImgLibrary.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        openImgLibrary.bottomAnchor.constraint(equalTo: imagesupload.topAnchor, constant: 120).isActive = true
        
        
        view.addSubview(openImgTBL)
        openImgTBL.topAnchor.constraint(equalTo: totalLabel.bottomAnchor, constant: 10).isActive = true
        openImgTBL.rightAnchor.constraint(equalTo: imagesupload.rightAnchor).isActive = true
        openImgTBL.leftAnchor.constraint(equalTo: imagesupload.leftAnchor).isActive = true
        openImgTBL.heightAnchor.constraint(equalToConstant: 70).isActive = true
    }
```

2. Select image from Image Library
```
func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imagesupload.image = pickedImage
           
            
        }
        //imagesupload.image = UIImage(named: "eightcoins11.jpg");
        dismiss(animated: true, completion: nil)
        
        
    }
    
  ```
  
  Use OpenCV Code to detect coins
  1. Blur the image first
  ```
  cv::Mat src,src_gray,newimage,mask;
    src = [self cvMatFromUIImage:image];
    cv::cvtColor(src, src_gray, CV_RGB2GRAY);
    cv::Size_<int> sizes2 = cv::Size(7,7);
    cv::GaussianBlur(src_gray, src_gray, sizes2, 0);
  ```
  2. Use Hough Circle to find circles in the image
  ```
  cv::HoughCircles(src_gray, circles, CV_HOUGH_GRADIENT, 1, src_gray.rows/6);
  ```
  3. For each of the circle detected, draw the circle and bound each of them with a rectangle. Then crop and store them into an array
  ```
  for (int i = 0 ; i<circles.size(); i++) {
        cv::Point center(cvRound(circles[i][0]), cvRound(circles[i][1]));
       
        //cv::Rect newrect = cv::boundingRect(newarray);
        
        int radius = cvRound(circles[i][2]);
        
        cout<<"radius is "<<radius<<endl;
        if(radius <= 400){
                cv::circle(src, center, radius, cv::Scalar(255,100,3),10);
                cv::rectangle(src, cvPoint((center.x)-(radius+10),(center.y)-(radius+10)), cvPoint((center.x)+(radius+10),(center.y)+(radius+10)), cv::Scalar(255,100,3),5);
                cv::Rect rrect(cvPoint((center.x)-(radius+10),(center.y)-(radius+10)), cvPoint((center.x)+(radius+10),(center.y)+(radius+10)));
                cv::Mat croppedimage = src(rrect);
            
                croppedimage.copyTo(mask);
                UIImage* newimage2 = [self UIImageFromCVMat:mask ];
                [imagesArray addObject:newimage2];
        }

    }
  ```
  Return Result
  
