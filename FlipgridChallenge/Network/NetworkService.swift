//
//  NetworkService.swift
//  FlipgridChallenge
//
//  Created by Lokesha Saralikana on 11/23/21.
//

import Foundation

protocol NetworkServiceProtocol {
    // Add submit
    func submitProfile(profile: Profile, completion: @escaping (Result<Profile, Error>) -> Void)
}

/* If the project is going to get bigger, I would consider using Alamofire as that would make
   things easier on the API integration side.
   We could also use URLSession with protocol oriented approach to handle the networking.
   If mocking of network layer is essential, then we could inject the URL session instance.
*/
class NetworkService: NetworkServiceProtocol {
    /*
     Out of scope:
     Invoke submit API endpoint (potentially a REST endpoint with support for multipart/form-data) and decode the response
     (We may need to send additional meta data like filename, file type etc when avatar is present)
     Check for success and failure in the response object and pass the result in completion handler.
     To simualate the network activity, I'm invoking sleep() before callng the completion.
     */
    func submitProfile(profile: Profile, completion: @escaping (Result<Profile, Error>) -> Void) {
        DispatchQueue.global().async {
            sleep(1)
            completion(.success(profile))
        }
    }
}
