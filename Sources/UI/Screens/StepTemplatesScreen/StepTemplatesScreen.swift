//
//  StepTemplatesScreen.swift
//  Workouter
//
//  Created by Uladzimir Papko on 12/29/14.
//  Copyright (c) 2014 visput. All rights reserved.
//

import UIKit

final class StepTemplatesScreen: BaseScreen {

    var templateDidSelectAction: ((step: Step) -> Void)?
    
    var searchRequest = StepsSearchRequest(workout: Workout.emptyWorkout(), muscleGroup: nil, searchText: "")
    
    private var steps = [Step]()
    
    private var workoutsProvider: WorkoutsProvider {
        return modelProvider.workoutsProvider
    }
    private var templatesView: StepTemplatesView {
        return view as! StepTemplatesView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fillViewWithSearchRequest(searchRequest)
        searchStepsWithRequest(searchRequest)
    }
}
    
extension StepTemplatesScreen: ActionableCollectionViewDelegate, UICollectionViewDataSource {
        
    func collectionView(collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {
            
            return steps.count
    }
    
    func collectionView(collectionView: UICollectionView,
        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
            var resultCell: ActionableCollectionViewCell! = nil
            
            let step = steps[indexPath.item]
            
            if step.isEmpty() {
                let cell = collectionView.dequeueReusableCellWithReuseIdentifier(NewStepTemplateCell.className(),
                    forIndexPath: indexPath) as! NewStepTemplateCell
                let item = NewStepTemplateCellItem()
                cell.fillWithItem(item)
                resultCell = cell
                
            } else {
                let cell = collectionView.dequeueReusableCellWithReuseIdentifier(StepTemplateCell.className(),
                    forIndexPath: indexPath) as! StepTemplateCell
                let item = StepTemplateCellItem(step: step)
                cell.fillWithItem(item)
                resultCell = cell
            }
            
            return resultCell
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            
            return templatesView.templateCellSizeAtIndexPath(indexPath)
    }
    
    func collectionView(collectionView: ActionableCollectionView,
        willExpandCellAtIndexPath indexPath: NSIndexPath) {
            
            templatesView.searchBar.setShowsCancelButton(false, animated: true)
            templatesView.searchBar.resignFirstResponder()
    }
}

extension StepTemplatesScreen: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        searchRequest = searchRequest.requestBySettingSearchText(searchText)
        searchStepsWithRequest(searchRequest)
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
        searchBar.text = ""
        searchRequest = searchRequest.requestBySettingSearchText("")
        searchStepsWithRequest(searchRequest)
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
    }
}

extension StepTemplatesScreen {
    
    private func searchStepsWithRequest(searchRequest: StepsSearchRequest) {
        steps = [Step]()
        steps.append(Step.emptyStep())
        
        let searchResults = workoutsProvider.searchStepsWithRequest(searchRequest)
        steps.appendContentsOf(searchResults)
        
        templatesView.templatesCollectionView.reloadData()
        templatesView.templatesCollectionView.collapseExpandedCell()
    }
    
    private func fillViewWithSearchRequest(searchRequest: StepsSearchRequest) {
        if let muscleGroup = searchRequest.muscleGroup {
            title = muscleGroup.localizedName()
        } else {
            title = NSLocalizedString("All Exercises", comment: "")
        }
        templatesView.searchBar.text = searchRequest.searchText
    }
}
