//
//  ScanQRController.swift
//  ContactExchange
//
//  Created by Matt Roberts on 6/12/19.
//  Copyright © 2019 Matt Roberts. All rights reserved.
//
import UIKit
import AVFoundation
import Contacts

import Foundation

class ScanQRController: NSObject, AVCaptureMetadataOutputObjectsDelegate{
    
    private var scanQR_VC: ScanQR_VC!
    
    //boolean for if the qr is a valid contact
    private var validContact=false
    
    //for AV input
    private let session = AVCaptureSession()
    //so code can be run not on the main thread
    private let sessionQueue = DispatchQueue(label: "session queue")
    //for AV output
    private var avPreviewLayer: AVCaptureVideoPreviewLayer!
    
    //the types the view will look for
    private let metaDataTypes=[AVMetadataObject.ObjectType.qr]
    
    //the view that will try to go aroung the QR code
    private let qrCodeFocusView=UIView()
    
    //the string from the qr code or an empty string
    private var qrString=""
    
    init(scanQR_VC: ScanQR_VC){
        super.init()
        self.scanQR_VC=scanQR_VC
        
        //create a layer that will show camera output
        initializeAVPreviewLayer()
        do{
            //try to get video camera and start AV session
            try initializeAVSession(videoCamera: try getVideoCamera())
            //start AV session--success
            session.startRunning()
        } catch {
            //tell error
            print("Couldn't get video input: \(error)")
            //end configuring
            session.commitConfiguration()
            return
        }
        //add layer that shows camera output to scanView
        addAVPreviewToScanView()
        do{
            //try to add metadata output
            try addMetaDataOuput()
        } catch {
            //tell error
            print("Couldn't add metadata output: \(error)")
            return
        }
        setUpFocusRectangle()
        scanQR_VC.getSaveContactBanner().isHidden=true
        scanQR_VC.getSaveContactBanner().setTapActionCallable(tapActionCallable: AddContactNotifier())
        NotificationCenter.default.addObserver(self, selector: #selector(respondToContactBannerTap), name: .contactBannerTapped, object: nil)
    }
    
    func initializeAVPreviewLayer(){
        avPreviewLayer = AVCaptureVideoPreviewLayer(session: session)
        avPreviewLayer.frame = scanQR_VC.getScanView().layer.bounds
        avPreviewLayer.videoGravity = .resizeAspectFill
    }
    
    func addAVPreviewToScanView(){
        let viewLayer: CALayer = scanQR_VC.getScanView().layer
        viewLayer.masksToBounds=true
        viewLayer.addSublayer(self.avPreviewLayer)
    }
    
    func addMetaDataOuput() throws{
        let metaDataOutput = AVCaptureMetadataOutput()
        
        if (session.canAddOutput(metaDataOutput)) {
            session.addOutput(metaDataOutput)
            
            metaDataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metaDataOutput.metadataObjectTypes = metaDataTypes
        } else {
            throw VideoOutputError.outputAdditionFailure("Could not add metadata pouput to AV session")
        }
    }
    
    func getVideoCamera() throws->AVCaptureDevice{
        
        //get a video camera or throw an error
        if let dualCamera = AVCaptureDevice.default(.builtInDualCamera, for: .video, position: .back) {
            return dualCamera
        } else if let backCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
            return backCamera
        } else if let frontCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) {
            return frontCamera
        }
        else{
            //if there is no video camera, throw an error
            throw VideoInputError.noCamera("No Camera Error")
        }
        
    }
    
    func initializeAVSession(videoCamera: AVCaptureDevice) throws{
        
        //begin configuration--doesn't end until commitConfiguration is called
        session.beginConfiguration()
        session.sessionPreset = .photo
        //check one last time that the app is authorized for video and throw an error if not authorized
        if (AVCaptureDevice.authorizationStatus(for: .video)==AVAuthorizationStatus.authorized)
            
        {
            //get input from the chosen video camera
            let videoCameraInput = try AVCaptureDeviceInput(device: videoCamera)
            //add AV input to session or throw an error
            
            if session.canAddInput(videoCameraInput) {
                //add the video input to the AV session
                session.addInput(videoCameraInput)
                //end configuring
                session.commitConfiguration()
            }
            else{
                //if the AV input couldn't be added to the AV session
                throw VideoInputError.inputAdditionFailure("Couldn't add AV input to AV session")
            }
            
        }
        else{
            //if somehow the program got here but the camera was not authorized for video
            throw VideoInputError.noAuthorization("Camera video usage was not authorized")
        }
        
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection){
        //Swift.print(metadataObjects.first?.description)
        if (metadataObjects.first != nil){
            qrCodeFocusView.isHidden=false
            scanQR_VC.getSaveContactBanner().isHidden=false
            let transformedMetaDataObj=avPreviewLayer.transformedMetadataObject(for: metadataObjects.first!)
            qrCodeFocusView.frame = transformedMetaDataObj!.bounds
            let qrCode=transformedMetaDataObj as! AVMetadataMachineReadableCodeObject
            if (qrCode.stringValue != nil){
                if (qrString != qrCode.stringValue){
                    qrString=qrCode.stringValue!
                    validContact=false
                    do{
                        let cnContactArray=try ContactDataConverter.createCNContactArray(vCardString: qrString)
                        scanQR_VC.getSaveContactBanner().messageLabel.text="Save to contacts"
                        if (cnContactArray.first==nil){
                            throw DataConversionError.badVCard("It's not a v card")
                        }
                        validContact=true
                        scanQR_VC.getSaveContactBanner().detailLabel.text = ContactInfoManipulator.createContactPreviewString(cnContact: cnContactArray.first!)
                        scanQR_VC.getSaveContactBanner().imageView.image=ContactDataConverter.makeQRCode(string: qrString)
                    }
                    catch{
                        validContact=false
                        scanQR_VC.getSaveContactBanner().messageLabel.text="Not a Contact"
                        scanQR_VC.getSaveContactBanner().detailLabel.text="Code doesn't have a readbale contact."
                        scanQR_VC.getSaveContactBanner().imageView.image=UIImage()
                    }
                    
                }
            }
        }
        else{
            qrCodeFocusView.isHidden=true
            scanQR_VC.getSaveContactBanner().isHidden=true
            qrString=""
            scanQR_VC.getSaveContactBanner().imageView.image=UIImage()
        }
    }
    
    func setUpFocusRectangle(){
        qrCodeFocusView.layer.borderColor = UIColor.yellow.cgColor
        qrCodeFocusView.layer.borderWidth = 2
        qrCodeFocusView.backgroundColor=UIColor.clear
        scanQR_VC.getScanView().addSubview(qrCodeFocusView)
        scanQR_VC.getScanView().bringSubviewToFront(qrCodeFocusView)
        qrCodeFocusView.isHidden=true
    }
    
    class AddContactNotifier: Callable{
        
        func call() {
            NotificationCenter.default.post(name: .contactBannerTapped, object: self)
        }
        
        
    }
    
    @objc private func respondToContactBannerTap(notification: NSNotification){
        /*
         if bad input, dismiss
         if good input, ask permission and add contact
         hide the notification when action is done
         */
        
        if(validContact){
            
        }
        
        scanQR_VC.getSaveContactBanner().isHidden=true
        qrCodeFocusView.isHidden=true
    }
    
    
}

/*
 Post this WHENEVER contact banner is tapped
 */
extension Notification.Name{
    
    //Reference as .contactChanged when type inference is possible
    static let contactBannerTapped=Notification.Name("contact-banner-tapped")
}

//some errors that can occur when working with the camera and AV sessions
enum VideoInputError: Error{
    case noCamera(String)
    case inputAdditionFailure(String)
    case noAuthorization(String)
}

enum VideoOutputError: Error{
    case outputAdditionFailure(String)
}
