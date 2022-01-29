//
//  Home.swift
//  UI-442 (iOS)
//
//  Created by nyannyan0328 on 2022/01/29.
//

import SwiftUI

struct Home: View {
    @StateObject var model = IconImageViewModel()
    
    @Environment(\.self) var env
    var body: some View {
        VStack(spacing:30){
            
            
            if let image = model.pickedImage{
                
                
                Image(nsImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 250, height: 250)
                    .clipped()
                    .onTapGesture {
                        
                        model.pickeImage()
                      
                    }
                
                
                Button {
                    
                    model.generateIconSet()
                    
                } label: {
                    
                    
                    
                    Text("Create Icon Set")
                        .font(.caption2)
                        .foregroundColor(.gray)
                        .padding(.vertical,10)
                        .padding(.horizontal,20)
                        .background(.white,in: RoundedRectangle(cornerRadius: 15))
                    
                    
                    
                    
                }
                .padding(.top,20)

                
                
                
            }
            
            else{
                
                
                
                ZStack{
                    
                    Button {
                        
                        model.pickeImage()
                        
                    } label: {
                        
                        
                        Image(systemName: "plus")
                            .font(.system(size: 25, weight: .bold))
                            .foregroundColor(env.colorScheme == .dark ? .black : .white)
                            .padding(10)
                            .background(.primary,in:RoundedRectangle(cornerRadius: 5))
                        
                    }
                    
                    
                    Text("1024 * 1024 is Recommended")
                        .font(.title3.weight(.semibold))
                        .foregroundColor(.gray)
                        .padding(.bottom,20)
                        .frame(maxHeight: .infinity, alignment: .bottom)

                    
                    
                }
                
                
                
                
                
            }
        }
        .frame(width: 500, height: 500)
        .buttonStyle(.plain)
        .alert(model.alertMSG, isPresented: $model.showAlret) {
            
            
            
        }
        .overlay{
        
            ZStack{
                
                
                if model.isGenerating{
                    
                    Color.black.opacity(0.25)
                    
                    
                    ProgressView()
                        .padding()
                        .background(.white,in: RoundedRectangle(cornerRadius: 20))
                        .environment(\.colorScheme, .light)
                }
            }
        
            }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
