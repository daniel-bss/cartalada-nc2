//
//  AppViewModel.swift
//  BelajarSceneKit
//
//  Created by Daniel Bernard Sahala Simamora on 18/02/24.
//

import SwiftUI
import RealityKit
import CoreData

class AppViewModel: ObservableObject {
    
    var paperColor: Color = .red
    var words: String = ""
    
    @Published var isShowingWelcomeView = true
    @Published var didFinishPosting = false
    
    @Published var planeTranslation: SIMD3<Float> = SIMD3<Float>(0, -0.3, -0.45)
    @Published var rotation: simd_quatf = simd_quatf(angle: Float(0 * Double.pi / 180.0), axis: SIMD3<Float>(0, 1, 0))
    
    @Published var paperSizes: [ChoosePaper] = [
        ChoosePaper(color: .red, frameSize: 75, realDimension: 20, isClicked: true),
        ChoosePaper(color: .red, frameSize: 90, realDimension: 25, isClicked: false),
        ChoosePaper(color: .red, frameSize: 105, realDimension: 30, isClicked: false)
    ]
    
    @Published var paperSize: PaperSize = .small
    
    // MARK: CORE DATA SETUPS
    var postedPapers = [PaperEntity]()
    let container: NSPersistentContainer
    
    public init() {
        container = NSPersistentContainer(name: "PaperContainers")
        container.loadPersistentStores { description, error in
            print("Core Data Desc: \(description)")
            if let error {
                print("ERROR WHEN LOADING CORE DATA. \(error)")
            }
        }
        
        fetchPapers()
    }
    
    func fetchPapers() {
        let request = NSFetchRequest<PaperEntity>(entityName: "PaperEntity")
        
        do {
            postedPapers = try container.viewContext.fetch(request)
        } catch {
            print("ERROR WHEN FETCHING. \(error)")
        }
    }
    
    func addPaper(postedPaper: PostedPaper) {
        let paper = PaperEntity(context: container.viewContext)
        
        paper.id = UUID()
        paper.color = postedPaper.color.description
        paper.paperSize = postedPaper.paperSize.rawValue
        paper.words = postedPaper.words
        paper.xPosition = postedPaper.position.x
        paper.yPosition = postedPaper.position.y
        
        saveData()
        print("FINISHED SAVING")
    }
    
    func saveData() {
        do {
            try container.viewContext.save()
            fetchPapers()
            print("SUCCEED SAVING")
        } catch {
            print("ERROR WHEN SAVING DATA. \(error)")
        }
    }
    
}
