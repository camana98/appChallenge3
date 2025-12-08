//
//  Fonts.swift
//  Glyptis
//
//  Created by Eduardo Camana on 26/11/25.
//

import SwiftUI

struct Fonts {
    
    //MARK: Helpers pra evitar repetir o nome da fonte em todo lugar
    private static func angleSquare(_ size: CGFloat) -> Font {
        .custom("AngleSquareDEMO", size: size)
    }
    
    private static func notoBold(_ size: CGFloat) -> Font {
        .custom("NotoSans-Bold", size: size)
    }
    
    private static func notoExtraBold(_ size: CGFloat) -> Font {
        .custom("NotoSans-ExtraBold", size: size)
    }
    
    private static func notoRegular(_ size: CGFloat) -> Font {
        .custom("NotoSans-Regular", size: size)
    }
    
    private static func notoSemiBold(_ size: CGFloat) -> Font {
        .custom("NotoSans-SemiBold", size: size)
    }
    
    private static func notoMedium(_ size: CGFloat) -> Font {
        .custom("NotoSans-Medium", size: size)
    }

    static var title: Font {
        angleSquare(24)
    }
    
    static var title2: Font {
        notoSemiBold(17)
    }
        
    static var notoSemi: Font {
        notoSemiBold(14)
    }
    
    static var notoSculptureName: Font {
        notoSemiBold(13)
    }
        
    static var notoRegular: Font {
        notoRegular(14)
    }
    
    static var notoFootnote: Font {
        notoRegular(13)
    }
    
    static var notoCubeButton: Font {
        notoMedium(15)
    }
}
