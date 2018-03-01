//
//  PastelExtensions.swift
//  Blip
//
//  Created by Srikanth Srinivas on 3/1/18.
//  Copyright © 2018 Blip Groceries. All rights reserved.
//

import Foundation
import Pastel

extension PastelView{
    
    func prepareDefaultPastelView(){
        
        let colors = [#colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1), #colorLiteral(red: 0, green: 0.8495121598, blue: 0, alpha: 1), #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)]
        self.setColors(colors)
        self.animationDuration = 3
    }
    
    func prepareCustomPastelViewWithColors(colors: [UIColor]){
        
        self.setColors(colors)
        self.animationDuration = 3
    }
    
}
