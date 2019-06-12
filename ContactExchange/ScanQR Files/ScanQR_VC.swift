//
//  ScanQR_VC.swift
//  CardQR
//
//  Created by Matt Roberts on 6/5/19.
//  Copyright © 2019 Matt Roberts. All rights reserved.
//

import UIKit
import AVFoundation
import Contacts

class ScanQR_VC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, AVCaptureMetadataOutputObjectsDelegate {
    
    //the view for scanning qr codes
    @IBOutlet weak var scanView: UIView!
    
    @IBOutlet weak var saveContactBanner: SaveContactBanner!
    
    private var validContact=false
    
    
    //for AV input
    private let session = AVCaptureSession()
    //so code can be run not on the main thread
    private let sessionQueue = DispatchQueue(label: "session queue")
    //for AV output
    private var avPreviewLayer: AVCaptureVideoPreviewLayer!
    
    private let metaDataTypes=[AVMetadataObject.ObjectType.qr]
    
    private let qrCodeFocusView=UIView()
    
    private let globalDispatchQueue = DispatchQueue.global()
    
    private var hideFocusRectTask: DispatchWorkItem!
    
    private var qrString=""
    
    /*AVMetadataObject.ObjectType.aztec, AVMetadataObject.ObjectType.code128, AVMetadataObject.ObjectType.code39, AVMetadataObject.ObjectType.code39Mod43, AVMetadataObject.ObjectType.code93, AVMetadataObject.ObjectType.dataMatrix, AVMetadataObject.ObjectType.ean13,AVMetadataObject.ObjectType.ean8,*/
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        saveContactBanner.isHidden=true
        saveContactBanner.setTapActionCallable(tapActionCallable: AddContactNotifier())
        NotificationCenter.default.addObserver(self, selector: #selector(respondToContactBannerTap), name: .contactChanged, object: nil)
    }
    
    func initializeAVPreviewLayer(){
        avPreviewLayer = AVCaptureVideoPreviewLayer(session: session)
        avPreviewLayer.frame = scanView.layer.bounds
        avPreviewLayer.videoGravity = .resizeAspectFill
    }
    
    func addAVPreviewToScanView(){
        let viewLayer: CALayer = scanView.layer
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
            saveContactBanner.isHidden=false
            let transformedMetaDataObj=avPreviewLayer.transformedMetadataObject(for: metadataObjects.first!)
            qrCodeFocusView.frame = transformedMetaDataObj!.bounds
            let qrCode=transformedMetaDataObj as! AVMetadataMachineReadableCodeObject
            if (qrCode.stringValue != nil){
                if (qrString != qrCode.stringValue){
                    qrString=qrCode.stringValue!
                    validContact=false
                    do{
                        let cnContactArray=try ContactDataConverter.createCNContactArray(vCardString: qrString)
                        saveContactBanner.messageLabel.text="Save to contacts"
                        if (cnContactArray.first==nil){
                            throw DataConversionError.badVCard("It's not a v card")
                        }
                        validContact=true
                        saveContactBanner.detailLabel.text = ContactInfoManipulator.createContactPreviewString(cnContact: cnContactArray.first!)
                        saveContactBanner.imageView.image=ContactDataConverter.makeQRCode(string: qrString)
                    }
                    catch{
                        validContact=false
                        saveContactBanner.messageLabel.text="Not a Contact"
                        saveContactBanner.detailLabel.text="Code doesn't have a readbale contact."
                        saveContactBanner.imageView.image=UIImage()
                    }
                    
                }
            }
        }
        else{
            qrCodeFocusView.isHidden=true
            saveContactBanner.isHidden=true
            qrString=""
            saveContactBanner.imageView.image=UIImage()
        }
    }
    
    func setUpFocusRectangle(){
        qrCodeFocusView.layer.borderColor = UIColor.yellow.cgColor
        qrCodeFocusView.layer.borderWidth = 2
        qrCodeFocusView.backgroundColor=UIColor.clear
        scanView.addSubview(qrCodeFocusView)
        scanView.bringSubviewToFront(qrCodeFocusView)
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
        else{
            
        }
        saveContactBanner.isHidden=true
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
