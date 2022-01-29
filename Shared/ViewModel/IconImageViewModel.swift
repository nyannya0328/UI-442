//
//  IconImageViewModel.swift
//  UI-442 (iOS)
//
//  Created by nyannyan0328 on 2022/01/29.
//

import SwiftUI

class IconImageViewModel: ObservableObject {
    @Published var pickedImage : NSImage?
    
    @Published var isGenerating : Bool = false
    @Published var showAlret : Bool = false
    @Published var alertMSG : String = ""
    
    
    @Published var iconSizes: [Int] = [
    
        20,60,58,87,80,120,180,40,29,76,152
        ,167,1024,16,32,64,128,256,512,1024
    ]
    
    
    
    func pickeImage(){
        
        
        let pannel = NSOpenPanel()
        
        pannel.title = "Chose a Picture"
        pannel.showsResizeIndicator = true
        pannel.showsHiddenFiles = false
        pannel.allowsMultipleSelection = false
        pannel.canChooseDirectories = false
        pannel.allowedContentTypes = [.png,.jpeg,.png]
        
        
        if pannel.runModal() == .OK{
            
            
            if let result = pannel.url?.path{
                
                
                let image = NSImage(contentsOf: URL(fileURLWithPath: result))
                
                self.pickedImage = image
                
            }
            
            
            
        }
        else{
            
            
            
        }
        
    }
    
    
    
    func generateIconSet(){
        
        
        folderSelector { folderURL in
            
            
            
            let modifieredURL = folderURL.appendingPathComponent("AppIcon.appiconset")
            
            self.isGenerating = true
            
            
            DispatchQueue.global(qos: .userInteractive).async{
            
            do{
                
                
                let manager = FileManager.default
                
                try manager.createDirectory(at: modifieredURL, withIntermediateDirectories: true, attributes: [:])
                
                self.writeContentsFile(forURL: modifieredURL.appendingPathComponent("Contents.json"))
                
                
                if let pickedImage = self.pickedImage{
                    
                    
                    self.iconSizes.forEach { size in
                        
                        
                        
                        let imageSize = CGSize(width: CGFloat(size), height: CGFloat(size))
                        
                        
                        let imageURL = modifieredURL.appendingPathComponent("\(size).png")
                        
                        
                        pickedImage.resizeImage(size: imageSize)
                            .writeImage(to: imageURL)
                    }
                    
                    
                    DispatchQueue.main.async {
                        
                        self.isGenerating = false
                        self.alertMSG = "Generated Scuuccefull"
                        self.showAlret.toggle()
                    }
                    
                    
                    
                    
                }
                
                
                
            }
            
            catch{
                
                print(error.localizedDescription)
                
                
                DispatchQueue.main.async {
                    
                    self.isGenerating = false
                    
                }
            }
            }
            
        }
        
        
        
    }
    
    
    func folderSelector(competition : @escaping(URL) -> ()){
        
        let pannel = NSOpenPanel()
        pannel.title = "Choose a Folder"
        pannel.showsResizeIndicator = true
        pannel.showsHiddenFiles = false
        pannel.allowsMultipleSelection = false
        pannel.canChooseDirectories = true
        pannel.canChooseFiles = false
        pannel.canCreateDirectories = true
        pannel.allowedContentTypes = [.folder]
        
        
        if pannel.runModal() == .OK{
            
            
            if let result = pannel.url?.path{
                
                competition(URL(fileURLWithPath: result))
                
            }
            
            else{
                
                
                
            }
        }
        
        
        
    }
    
    
    func writeContentsFile(forURL : URL){
        
        do{
            
            let bundle = Bundle.main.path(forResource: "Contents", ofType: "json") ?? ""
            
            let url = URL(fileURLWithPath: bundle)
            
            
            try Data(contentsOf: url).write(to: forURL, options: .atomic)
            
            
        }
        catch{
            
            
            
            
        }
        
        
    }
    
    
}

extension NSImage{
    
    
    
    func resizeImage(size : CGSize) -> NSImage{
        
        
        let scale = NSScreen.main?.backingScaleFactor ?? 1
        
        
        
        
        let newSize = CGSize(width: size.width / scale, height: size.height / scale)
        
        let newImage = NSImage(size: newSize)
        newImage.lockFocus()
        
    
        
        self.draw(in: NSRect(origin: .zero, size: newSize))
        
        newImage.unlockFocus()
        
        return newImage
        
    
        
        
        
        
    }
    
    func writeImage(to : URL){
        
        guard let data = tiffRepresentation,let representation = NSBitmapImageRep(data: data),let pingData = representation.representation(using: .png, properties: [:]) else{
            
            
            return
        }
        
        
        try? pingData.write(to: to, options: .atomic)
                
                
        
        
        
    }
    
}
