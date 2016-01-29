import Foundation
import Alamofire
import SwiftyJSON

let RequestAccessState = "RequestAccessState"

typealias ErrorHandler = (NSError) -> ()

class StravaClient {

    let clientId: String
    let clientSecret: String
    var accessToken: String!

    var localAthlete: Athlete?

    // Private
    private let authorizeURLTemplate = "https://www.strava.com/oauth/authorize?client_id=%@&response_type=code&redirect_uri=%@&state=%@"
    private let tokenExchangeTemplate = "https://www.strava.com/oauth/token"

    init(clientId: String, clientSecret: String) {
        self.clientId = clientId
        self.clientSecret = clientSecret
    }

    func requestAccessWithRedirectURL(url: String) {
        let authorizeURL = authorizeURLTemplate.format(clientId, url, RequestAccessState)
        UIApplication.sharedApplication().openURL(authorizeURL.URL!)
    }

    func handleRequestAccessCallbackWithURL(url: NSURL, success: ((Athlete) -> ())? = nil, failure: ErrorHandler? = nil) {

        let parameters = [
            "client_id" : clientId,
            "client_secret" : clientSecret,
            "code" : url.params["code"]!
        ]

        Alamofire
            .request(.POST, tokenExchangeTemplate, parameters: parameters)
            .responseJSON { response in
                let json = JSON(response.data!)
                self.accessToken = json["access_token"].string
                self.localAthlete = json["athlete"].athlete
                success?(self.localAthlete!)
            }
    }

    func performGetRequest(url: String, parameters: [String : AnyObject]?, success: (AnyObject) -> (), failure: ErrorHandler) {

        var parametersExpanded = parameters == nil ? [String : AnyObject]() : parameters!
        parametersExpanded["access_token"] = accessToken

        Alamofire
            .request(.GET, url, parameters: parametersExpanded)
            .responseJSON { response in
                if let error = response.result.error {
                    failure(error)
                }
                else {
                    success(response.result.value!)
                }
        }
    }
}