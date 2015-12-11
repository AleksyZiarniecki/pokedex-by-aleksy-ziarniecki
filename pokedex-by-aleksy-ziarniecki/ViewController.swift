//
//  ViewController.swift
//  pokedex-by-aleksy-ziarniecki
//
//  Created by user114747 on 12/10/15.
//  Copyright © 2015 BCUstudent. All rights reserved.
//

import UIKit
import AVFoundation
//Protocols
class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    //Creating an empty Pokemon array
    var pokemon = [Pokemon]()
    var filteredPokemon = [Pokemon]()
    var musicPlayer: AVAudioPlayer!
    var inSearchMode = false

    override func viewDidLoad() {
        super.viewDidLoad()
        collection.delegate = self
        collection.dataSource = self
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.Done
        
        initAudio()
        parsePokemonCSV()
        
    }
    
    func initAudio() {
        
        let path = NSBundle.mainBundle().pathForResource("music", ofType: "mp3")!
        
        do {
            musicPlayer = try AVAudioPlayer(contentsOfURL: NSURL(string: path)!)
            //If it worked
            musicPlayer.prepareToPlay()
            //Infinite number of loops
            musicPlayer.numberOfLoops = -1
            musicPlayer.play()
        } catch let err as NSError {
            print(err.debugDescription)
        }
        
    }
    
    func parsePokemonCSV() {
        //Grabbing path of csv file
        let path = NSBundle.mainBundle().pathForResource("pokemon", ofType: "csv")!
        
        do {
            let csv = try CSV(contentsOfURL: path)
            let rows = csv.rows
            
            //for each loop
            for row in rows {
                let pokeId = Int(row["id"]!)!
                let name = row["identifier"]!
                let poke = Pokemon(name: name, pokedexId: pokeId)
                //Creating and adding pokemon to the array
                pokemon.append(poke)
            }
            
            
        //Error catching
        } catch let err as NSError {
            print(err.debugDescription)
        }
        
        
    }
    //Everytime screen needs cell it will call this function
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        //If successfuly grabbed an empty cell of type PokemonCell - return it
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PokemonCell", forIndexPath: indexPath) as? PokemonCell {
            //.row looping through data and grabbing it out of it
            
            let poke: Pokemon!
            
            if inSearchMode {
                poke = filteredPokemon[indexPath.row]
                
            } else {
                poke = pokemon[indexPath.row]
            }
            cell.configureCell(poke)
            return cell
        //If it fails create an empty generic cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let poke : Pokemon!
        if inSearchMode {
            poke = filteredPokemon[indexPath.row]
            
        } else {
            poke = pokemon[indexPath.row]
        }
        
        print(poke.name)
        performSegueWithIdentifier("PokemonDetailVC", sender: poke)
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //If in search mode return count of filtered Pokemon
        if inSearchMode {
            return filteredPokemon.count
            
        }
        //If not in search mode return regular count of Pokemon
        return pokemon.count
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSizeMake(105, 105)
    }

   
    @IBAction func musicBtn(sender: UIButton!) {
        //Fading out music button when music stopped 
        if musicPlayer.playing {
            musicPlayer.stop()
            sender.alpha = 0.2
        } else {
            musicPlayer.play()
            sender.alpha = 1.0
        }
        
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text == nil || searchBar.text == "" {
            inSearchMode = false
            //Whenever all characters are gone end editing close keyboard
            view.endEditing(true)
            collection.reloadData()
        } else {
            inSearchMode = true
            let lower = searchBar.text!.lowercaseString
            //Passsing in a closure expression
            filteredPokemon = pokemon.filter({$0.name.rangeOfString(lower) != nil})
            //Refreshing collection view
            collection.reloadData()
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "PokemonDetailVC" {
            if let detailsVC = segue.destinationViewController as? PokemonDetailVC {
                if let poke = sender as? Pokemon {
                    detailsVC.pokemon = poke 
                }
            }
        }
    }

}

