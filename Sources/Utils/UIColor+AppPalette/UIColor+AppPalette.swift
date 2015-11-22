//
//  UIColor+AppPalette.h
//
//  Created on 11/22/15.
//

import UIKit

extension UIColor {

    class func primaryColor() -> UIColor {
        return UIColor(red: 0.1294117718935013,
            green:0.8078431487083435,
            blue:0.6000000238418579,
            alpha:1)
    }

    class func transparentPrimaryColor() -> UIColor {
        return UIColor(red: 0.1294117718935013,
            green:0.8078431487083435,
            blue:0.6000000238418579,
            alpha:0.09803921729326248)
    }

    class func lightPrimaryColor() -> UIColor {
        return UIColor(red: 0.4431372582912445,
            green:0.8941176533699036,
            blue:0.7568627595901489,
            alpha:1)
    }

    class func darkPrimaryColor() -> UIColor {
        return UIColor(red: 0,
            green:0.5686274766921997,
            blue:0.3960784375667572,
            alpha:1)
    }

    class func secondaryColor() -> UIColor {
        return UIColor(red: 0.1803921610116959,
            green:0.4745098054409027,
            blue:0.8039215803146362,
            alpha:1)
    }

    class func lightSecondaryColor() -> UIColor {
        return UIColor(red: 0.47843137383461,
            green:0.6745098233222961,
            blue:0.8901960849761963,
            alpha:1)
    }

    class func darkSecondaryColor() -> UIColor {
        return UIColor(red: 0.0313725508749485,
            green:0.2823529541492462,
            blue:0.5647059082984924,
            alpha:1)
    }

    class func primaryTextColor() -> UIColor {
        return UIColor(red: 0.105882354080677,
            green:0.2156862765550613,
            blue:0.2705882489681244,
            alpha:1)
    }

    class func secondaryTextColor() -> UIColor {
        return UIColor(red: 0.6549019813537598,
            green:0.6549019813537598,
            blue:0.6549019813537598,
            alpha:1)
    }

    class func disabledStateColor() -> UIColor {
        return UIColor(red: 0.3490196168422699,
            green:0.3490196168422699,
            blue:0.3490196168422699,
            alpha:0.6980392336845398)
    }

    class func invalidStateColor() -> UIColor {
        return UIColor(red: 0.9333333373069763,
            green:0.239215686917305,
            blue:0.1490196138620377,
            alpha:1)
    }

    class func borderColor() -> UIColor {
        return UIColor(red: 0.5137255191802979,
            green:0.5686274766921997,
            blue:0.6039215922355652,
            alpha:0.6980392336845398)
    }

    class func backgroundColor() -> UIColor {
        return UIColor(red: 0.929411768913269,
            green:0.9411764740943909,
            blue:0.95686274766922,
            alpha:1)
    }

}
