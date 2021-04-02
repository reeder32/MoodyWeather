//
//  ColorGridViewController.swift
//  MoodyWeather
//
//  Created by Nicholas Reeder on 1/26/21.
//  Copyright © 2021 Nicholas Reeder. All rights reserved.
//
struct ColorGridView {
    let color: UIColor
    let name: String
    let temp: String
}
import UIKit

class ColorGridViewController: UIViewController {

    var colorGridViews: [ColorGridView] = []
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
     
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.register(UINib(nibName: "ColorCell", bundle: nil), forCellReuseIdentifier: "ColorCell")
        tableView.backgroundColor = .clear
        tableView.frame = view.frame
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.separatorColor = .clear
        tableView.tableFooterView = UIView()
        tableView.tableHeaderView = UIView()
        view.addSubview(tableView)
        // Do any additional setup after loading the view.
    }
    
    

 

}

extension ColorGridViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / CGFloat(colorGridViews.count)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NotificationCenter.default.post(name: .PageIndex, object: nil, userInfo: ["index": indexPath.row])
    }
}

extension ColorGridViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return colorGridViews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ColorCell", for: indexPath) as? ColorCell else {
            return UITableViewCell(style: .default, reuseIdentifier: "cell")
        }
        cell.formatCell(cgView: colorGridViews[indexPath.row])
        return cell
    }
    
    
}

class ColorCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    override func awakeFromNib() {
        nameLabel.font = Fonts.Bold.of(20)
        nameLabel.textColor = Constants.labelColor
        tempLabel.font = Fonts.Regular.of(18)
        tempLabel.textColor = Constants.subLabelColor
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        // TODO: cell selection should dismiss the tableview and go to the main view and scroll to the weather selected
        
    }
    func formatCell(cgView: ColorGridView) {
        backgroundColor = cgView.color
        nameLabel.text = cgView.name
        tempLabel.text = cgView.temp
    }
}
