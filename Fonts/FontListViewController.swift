//
//  FontListViewController.swift
//  Fonts
//
//  Created by Josh Elliott on 10/28/18.
//  Copyright © 2018 JoshElliott. All rights reserved.
//

import UIKit

class FontListViewController: UITableViewController {
    var fontNames: [String] = []
    var showsFavorites:Bool = false
    private var cellPointSize: CGFloat!
    private static let cellIdentifier = "FontName"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let preferredTableViewFont = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.headline)
        cellPointSize = preferredTableViewFont.pointSize
        tableView.estimatedRowHeight = cellPointSize
        
        if showsFavorites {
            navigationItem.rightBarButtonItem = editButtonItem()
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func fontForDisplay(atIndexPath indexPath: NSIndexPath) -> UIFont {
        let fontName = fontNames[indexPath.row]
        return UIFont(name: fontName, size: cellPointSize)!
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if showsFavorites {
            fontNames = FavoritesList.sharedFavoritesList.favorites
            tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        FavoritesList.sharedFavoritesList.moveItem(fromIndex: sourceIndexPath.row, toIndex: destinationIndexPath.row)
        fontNames = FavoritesList.sharedFavoritesList.favorites
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return fontNames.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FontListViewController.cellIdentifier, for: indexPath)

        cell.textLabel?.font = fontForDisplay(atIndexPath: indexPath as NSIndexPath)
        cell.textLabel?.text = fontNames[indexPath.row]
        cell.detailTextLabel?.text = fontNames[indexPath.row]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return showsFavorites
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if !showsFavorites {
            return
        }
        if editingStyle == UITableViewCell.EditingStyle.delete {
            let favorite = fontNames[indexPath.row]
            FavoritesList.sharedFavoritesList.removeFavorite(fontName: favorite)
            fontNames = FavoritesList.sharedFavoritesList.favorites
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let tableViewCell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: tableViewCell)!
        let font = fontForDisplay(atIndexPath: indexPath as NSIndexPath)
        
        if segue.identifier == "ShowFontSizes" {
            let sizesVC = segue.destination as! FontSizesViewController
            sizesVC.title = font.fontName
            sizesVC.font = font
        } else {
            let infoVC = segue.destination as! FontInfoViewController
            infoVC.title = font.fontName
            infoVC.font = font
            infoVC.favorite = FavoritesList.sharedFavoritesList.favorites.contains(font.fontName)
        }
    }


}
