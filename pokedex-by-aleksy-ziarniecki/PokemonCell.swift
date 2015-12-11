//
//  PokemonCell.swift
//  pokedex-by-aleksy-ziarniecki
//
//  Created by user114747 on 12/10/15.
//  Copyright © 2015 BCUstudent. All rights reserved.
//

import UIKit

class PokemonCell: UICollectionViewCell {
    @IBOutlet weak var thumbImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    
    
    var pokemon: Pokemon!
    //Rounding edges of each cell
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        layer.cornerRadius = 6.0
    }
    //Whenever configCell gets called it will pass in Pokemon, its name and the image 
    func configureCell(pokemon: Pokemon) {
        self.pokemon = pokemon
        
        nameLbl.text = self.pokemon.name.capitalizedString
        thumbImg.image = UIImage(named: "\(self.pokemon.pokedexId)")
    }
    
}
