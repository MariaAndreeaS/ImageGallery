//
//  TableViewController.swift
//  ImageGallery
//
//  Created by Maria Andreea on 09.03.2022.
//

import UIKit

class TableViewController: UITableViewController {


    var counts = ["Gallery 1","Gallery 2","Gallery 3"]
    var deleted = [String]()

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return [counts,deleted][section].count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DocumentCell", for: indexPath)

        cell.textLabel?.text = [counts,deleted][indexPath.section][indexPath.row]

        return cell
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch(section) {
             case 1: return "Recently Deleted"
             default :return ""
           }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */


    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        if editingStyle == .delete {
            if indexPath.section == 0 {
               // Delete the row from the data source
                let del = counts.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                //  tableView.insertRows(at: [IndexPath(row: 0, section: 1)], with: .automatic)
                deleted.append(del)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
            deleted.remove(at: indexPath.row)
          }
        }
        tableView.reloadData()
    }


    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
           if indexPath.section == 1 {
               let unDelete = UIContextualAction(style: .normal, title: "Undelete") { [self] (action, view, completionHandler) in
                   let unDeletedItem = deleted.remove(at: indexPath.row)
                   counts.append(unDeletedItem)
                   completionHandler(true)
                   self.tableView.reloadData()
               }
               unDelete.backgroundColor = UIColor.systemGreen
               return UISwipeActionsConfiguration(actions: [unDelete])
           } else {
               return nil
           }
       }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
