//
//  ScanQRController.swift
//  ContactExchange
//
//  Created by Matt Roberts on 6/12/19.
//  Copyright © 2019 Matt Roberts. All rights reserved.
//
import UIKit
import AVFoundation
import ContactsUI
import Foundation

class GetQRController: NSObject, AVCaptureMetadataOutputObjectsDelegate{
    
    private var scanQRViewContr0ller: GetQRViewController!
    
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
    
    private var mainQueue=DispatchQueue.main
    
    private var contactToAdd: CNContact!
    
    private let addContactController=AddContactController()
    
    init(scanQRViewController: GetQRViewController){
        super.init()
        self.scanQRViewContr0ller=scanQRViewController
        setUpCameraView()
    }
    
    func setUpCameraView(){
        self.initializeAVPreviewLayer()
        print("AV preview layer ready "+(DispatchTime.now().uptimeNanoseconds/1000_000).description)
        self.addAVPreviewToScanView()
        print("AV preview layer added to scan view"+(DispatchTime.now().uptimeNanoseconds/1000_000).description)
        
        print("began setting up camera "+(DispatchTime.now().uptimeNanoseconds/1000_000).description)
        //create a layer that will show camera output
        //do{
        //try to get video camera and start AV session
        //start AV session--success
        sessionQueue.async {
            do{
                try self.initializeAVSession(videoCamera: try self.getVideoCamera())
                self.session.startRunning()
                print("session ready "+(DispatchTime.now().uptimeNanoseconds/1000_000).description)
                //add layer that shows camera output to scanView
                do{
                    //try to add metadata output
                    try self.addMetaDataOuput()
                } catch {
                    //tell error
                    print("Couldn't add metadata output: \(error)")
                    return
                }
            }
            catch {
                //tell error
                print("Couldn't get video input: \(error)")
                //end configuring
                self.session.commitConfiguration()
                return
            }
            /*
            DispatchQueue.main.async{
                self.initializeAVPreviewLayer()
                print("AV preview layer ready "+Date().description)
                self.addAVPreviewToScanView()
                print("AV preview layer added to scan view"+Date().description)
                //add layer that shows camera output to scanView
                do{
                    //try to add metadata output
                    try self.addMetaDataOuput()
                } catch {
                    //tell error
                    print("Couldn't add metadata output: \(error)")
                    return
                }
            }
 */
        }
        /*
         } catch {
         //tell error
         print("Couldn't get video input: \(error)")
         //end configuring
         session.commitConfiguration()
         return
         }
         */
        setUpFocusRectangle()
        scanQRViewContr0ller.saveContactBanner.isHidden=true
        scanQRViewContr0ller.saveContactBanner.setTapActionCallable(tapActionCallable: AddContactNotifier())
        NotificationCenter.default.addObserver(self, selector: #selector(respondToContactBannerTap), name: .contactBannerTapped, object: nil)
    }
    
    func startSession(){
        sessionQueue.async {
            self.session.startRunning()
        }
    }
    
    func initializeAVPreviewLayer(){
        avPreviewLayer = AVCaptureVideoPreviewLayer(session: session)
        avPreviewLayer.frame = scanQRViewContr0ller.scanView.layer.bounds
        avPreviewLayer.videoGravity = .resizeAspectFill
    }
    
    func addAVPreviewToScanView(){
        let viewLayer: CALayer = scanQRViewContr0ller.scanView.layer
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
            let transformedMetaDataObj=avPreviewLayer.transformedMetadataObject(for: metadataObjects.first!)
            qrCodeFocusView.frame = transformedMetaDataObj!.bounds
            guard let qrCode=transformedMetaDataObj as? AVMetadataMachineReadableCodeObject else{
                return
            }
            if (qrCode.stringValue != nil){
                if (qrString != qrCode.stringValue){
                    qrString=qrCode.stringValue!
                    validContact=false
                    do{
                        let cnContactArray=try ContactDataConverter.createCNContactArray(vCardString: qrString)
                        scanQRViewContr0ller.saveContactBanner.messageLabel.text="Save to contacts"
                        if (cnContactArray.first==nil){
                            throw DataConversionError.badVCard("It's not a v card")
                        }
                        validContact=true
                        scanQRViewContr0ller.saveContactBanner.detailLabel.text = ContactInfoManipulator.createContactPreviewString(cnContact: cnContactArray.first!)
                        scanQRViewContr0ller.saveContactBanner.imageView.image=ContactDataConverter.makeQRCode(string: qrString)
                        contactToAdd=cnContactArray.first!
                        qrCodeFocusView.isHidden=false
                        scanQRViewContr0ller.saveContactBanner.isHidden=false
                    }
                    catch{
                        validContact=false
                        scanQRViewContr0ller.saveContactBanner.messageLabel.text="Not a Contact"
                        scanQRViewContr0ller.saveContactBanner.detailLabel.text="Code doesn't have a readbale contact."
                        scanQRViewContr0ller.saveContactBanner.imageView.image=UIImage()
                    }
                    
                }
            }
        }
        else{
            qrString=""
            qrCodeFocusView.isHidden=true
            scanQRViewContr0ller.saveContactBanner.isHidden=true
            scanQRViewContr0ller.saveContactBanner.imageView.image=UIImage()
        }
    }
    
    func setUpFocusRectangle(){
        qrCodeFocusView.layer.borderColor = UIColor.yellow.cgColor
        qrCodeFocusView.layer.borderWidth = 2
        qrCodeFocusView.backgroundColor=UIColor.clear
        scanQRViewContr0ller.scanView.addSubview(qrCodeFocusView)
        scanQRViewContr0ller.scanView.bringSubviewToFront(qrCodeFocusView)
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
        print("respond to contact banner tapped"+Date().description)
        
        if(validContact){
            addContactController.showAddContactUI(presentingVC: scanQRViewContr0ller, contactToAdd: contactToAdd, forQR: false)
          
        }
        
        scanQRViewContr0ller.saveContactBanner.isHidden=true
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
