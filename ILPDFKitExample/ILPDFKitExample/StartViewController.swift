//
//  StartViewController.swift
//  ILPDFKitExample
//
//  Created by Eldhose Lomy on 02/07/18.
//  Copyright © 2018 Derek Blair. All rights reserved.
//

import UIKit
import ILPDFKit

class StartViewController: ILPDFViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let document = ILPDFDocument(resource:"testA")
        self.document = document
        let printButton = UIBarButtonItem(title: "Save Static PDF", style: .plain, target: self, action: #selector(save))
        self.navigationItem.setRightBarButton(printButton, animated: false)
        
    }

    func pdfPageChanged() {
        for form in document!.forms{
            if let fm = form as? ILPDFForm{
                
                if fm.formType == .button {
                    if isGroupedButton(selectedForm: fm){
                        fm.value = fm.exportValue
                    }
                    //print(fm.exportValue)
                }
                if fm.formType == .choice{
                    print("-------------------")
                    //dump(fm.options)
                }
                if fm.formType == .signature{
//                    if let an = fm.associatedWidget() as? ILPDFFormSignatureField{
//                        an.signatureImage =  #imageLiteral(resourceName: "signature")
//                    }
//                    print(fm.uname ?? "")
//                    print(fm.value)
                    //fm.
                    //showSignatureVC(fm)
                    //print(fm.uname)
                    //let image = UIImage(color: .red, size: fm.frame.size) ?? #imageLiteral(resourceName: "signature")
                    //signed(with: image, sig: fm)
                }
                
                
            }
        }
        //document!.forms.setValue("Yes", forFormWithName: "Sex[0]")
        
        
    }
    
    func isGroupedButton(selectedForm:ILPDFForm)->Bool{
        let forms = document!.forms!
        return (forms.filter{($0 as! ILPDFForm).name == selectedForm.name}).count > 1
    }
    

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        pdfPageChanged()
    }
    

    //MARK: Print Responder
    
    @objc func save(sender:AnyObject?) {
        
        
        
        let forms = document!.forms!
        for item  in forms{
            if (item as! ILPDFForm).formType == .signature{
                if let an = (item as! ILPDFForm).associatedWidget() as? ILPDFFormSignatureField{
                    an.signatureImage.image = #imageLiteral(resourceName: "signature")
                    an.informDelegateAboutNewImage()
                    an.signatureButton.setTitle("", for: .normal)
                    
                }
            }
        }
        
        
        let data = document?.savedStaticPDFData()
        let flatPDF = document?.savedStaticPDFData()
        
        let activityViewController: UIActivityViewController = UIActivityViewController(activityItems: [flatPDF!], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView=self.view
        present(activityViewController, animated: true, completion: nil)
        return
        
        let savedVCDocument = ILPDFDocument(data: data!)
        
        let alert : UIAlertController = UIAlertController(title: "Will Save PDF", message: "The PDF file displayed next is a static version of the previous file, but with the form values added. The starting PDF has not been modified and this static pdf no longer contains forms.", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Show Saved Static PDF", style: .default) { (_ : UIAlertAction) in
            alert.dismiss(animated: true, completion: nil)
            self.document = savedVCDocument
            self.navigationItem.setRightBarButton(nil, animated: false)
        }
        
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ILPDFFormContainer: Sequence {
    public func makeIterator() -> NSFastEnumerationIterator {
        return NSFastEnumerationIterator(self as NSFastEnumeration)
    }
}
public extension UIImage {
    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}
