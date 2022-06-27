//
//  LocalFileManager.swift
//  Krypton
//
//  Created by Adarsh Shukla on 26/03/22.
//

import Foundation
import UIKit

class LocalFileManager {
    static let instance = LocalFileManager() // singleton
    private init() {}
    
    //saving images
    func saveImages(image: UIImage, imageName: String, folderName: String) {
        //creating folder
        createFolderIfNeeded(folderName: folderName)
        
        // get path for image
        guard
            let data = image.pngData(),
            let urlPath = getURLForImage(imageName: imageName, folderName: folderName) else { return }
        
        // save image to path
        do {
            try data.write(to: urlPath)
            //print("Success saving")
        } catch let error {
            print("Error saving image. ImageName: \(imageName). \(error.localizedDescription)")
        }
    }
    
    //getting images back
    func getImage(imageName: String, folderName: String) -> UIImage? {
        guard
            let imageURL = getURLForImage(imageName: imageName, folderName: folderName)?.path,
            FileManager.default.fileExists(atPath: imageURL) else {
                //print("Error getting path.")
                return nil
            }
        return UIImage(contentsOfFile: imageURL)
    }
    
    // creating a folder
    private func createFolderIfNeeded(folderName: String) {
        guard let folderPathURL = getURLPathForFolder(folderName: folderName) else { return }
        
        // check whether folder exists or not.
        if !FileManager.default.fileExists(atPath: folderPathURL.path) {
            do {
                try FileManager
                    .default
                    .createDirectory(at: folderPathURL, withIntermediateDirectories: true, attributes: nil)
                //print("Success creating the folder")
            } catch let error {
                print("Error creating directory. FolderName: \(folderName). \(error.localizedDescription)")
            }
        }
    }
    
    //getting url path for folder
    private func getURLPathForFolder(folderName: String) -> URL? {
        guard let urlPath = getFolderPath() else { return nil }
        return urlPath.appendingPathComponent(folderName)
    }
    
    //getting image path or url
    private func getURLForImage(imageName: String, folderName: String) -> URL? {
        guard let folderURL = getURLPathForFolder(folderName: folderName) else { return nil }
        return folderURL.appendingPathComponent(imageName + ".png")
    }
    
    //helper func for folder path
    private func getFolderPath() -> URL? {
        return FileManager
            .default
            .urls(for: .cachesDirectory, in: .userDomainMask)
            .first
    }
}

/*
 services folder contains files mostly related to 3rd party
 utilities folder contains files mostly services kind of but related to more of internal stuffs.
 */

