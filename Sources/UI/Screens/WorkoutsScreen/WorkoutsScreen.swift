//
//  WorkoutsScreen.swift
//  SportTime
//
//  Created by Vladimir Popko on 12/28/14.
//  Copyright (c) 2014 visput. All rights reserved.
//

import UIKit

class WorkoutsScreen: BaseScreen {
    @IBOutlet private weak var tableView: UITableView!
    
    private var workoutsProvider: WorkoutsProvider {
        return modelProvider.workoutsProvider
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.workoutsProvider.loadWorkouts()
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
}

extension TableViewDelegate: UITableViewDelegate, UITableViewDataSource  {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.workoutsProvider.workouts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("WorkoutCell") as WorkoutCell
        cell.fill(workout: self.workoutsProvider.workouts[indexPath.row])
        return cell
    }
}

private typealias TableViewDelegate = WorkoutsScreen
