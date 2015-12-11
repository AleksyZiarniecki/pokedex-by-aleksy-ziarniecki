//
//  Pokemon.swift
//  pokedex-by-aleksy-ziarniecki
//
//  Created by user114747 on 12/10/15.
//  Copyright © 2015 BCUstudent. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    private var _name: String!
    private var _pokedexId: Int!
    private var _description: String!
    private var _type: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _nextEvolutionTxt: String!
    private var _nextEvolutionId: String!
    private var _nextEvolutionLvl: String!
    private var _pokemonUrl: String!
    
    //Getters (encapsulation) to make sure nobody can destroy data
    
    var description: String {
        //if nill return an empty string
        if _description == nil {
            _description = ""
        }
        return _description
    }
    
    var type: String {
        //if nill return an empty string
            if _type == nil {
                _type = ""
            }
            return _type
    }
    
    var defense: String {
        //if nill return an empty string
        if _defense == nil {
            _defense = ""
        }
        return _defense
    }
    
    var height: String {
        //if nill return an empty string
        if _height == nil {
            _height = ""
        }
        return _height
    }
    
    var weight: String {
        //if nill return an empty string
        if _weight == nil {
            _weight = ""
        }
        return _weight
    }
    
    var attack: String {
        //if nill return an empty string
        if _attack == nil {
            _attack = ""
        }
        return _attack
    }
    
    var nextEvolutionTxt: String {
         //if nill return an empty string
        if _nextEvolutionTxt == nil {
            _nextEvolutionTxt = ""
        }
        return _nextEvolutionTxt
    }
    
    var nextEvolutionId: String {
            //if nill return an empty string
            if _nextEvolutionId == nil {
                _nextEvolutionId = ""
            }
            return _nextEvolutionId
        }
    
    var nextEvolutionLvl: String {
         //if nill return an empty string
        if _nextEvolutionLvl == nil {
            _nextEvolutionLvl = ""
        }
        return _nextEvolutionLvl
    }
    //not possible to be nil becuase of initialiser
    var name: String {
        return _name
    }
    
    //not possible to be nil becuase of initialiser
    var pokedexId: Int {
        return _pokedexId
    }
    
    init(name: String, pokedexId: Int) {
        self._name = name
        self._pokedexId = pokedexId
        
        _pokemonUrl = "\(URL_BASE)\(URL_POKEMON)\(self.pokedexId)/"
    }
    //When download is complete 
    func downloadPokemonDetails(completed: DownloadComplete) {
        
        //Grabbing items out of JSON dictionary
        let url = NSURL(string: _pokemonUrl)!
        Alamofire.request(.GET, url).responseJSON { response in let result = response.result
            
            if let dict = result.value as? Dictionary<String, AnyObject> {
                
                if let weight = dict["weight"] as? String {
                    //self used because in closure
                    self._weight = weight
                }
                
                if let height = dict["height"] as? String {
                    self._height = height
                }
                
                if let attack = dict["attack"] as? Int {
                    self._attack = "\(attack)"
                }
                
                if let defense = dict["defense"] as? Int {
                    self._defense = "\(defense)"
                }
                
                print(self._weight)
                print(self._height)
                print(self._attack)
                print(self._defense)
                
                //types is an array of dictionaries 
                //each dictionary is of type string, string
                
                if let types = dict["types"] as? [Dictionary<String, String>]
                    //condition
                    where types.count > 0 {
                        //constant "type" grabbing first item "name" out of array
                        if let name = types[0]["name"] {
                            self._type = name.capitalizedString
                            }
                        //If more than 1 type of pokemon add / then 2nd type
                        if types.count > 1 {
                            
                            for var x = 1; x < types.count; x++ {
                                if let name = types[x]["name"] {
                                    self._type! += "/\(name.capitalizedString)"
                                }
                            }
                        }
                //If no types
                } else {
                    self._type = ""
                    
                }
                
                print(self._type)
                
                //Parsing out Pokemon description 
                if let descArr = dict["descriptions"] as? [Dictionary<String, String>] where descArr.count > 0 {
                    
                    if let url = descArr[0]["resource_uri"] {
                        let nsurl = NSURL(string: "\(URL_BASE)\(url)")!
                        Alamofire.request(.GET, nsurl).responseJSON { response in
                            //Request* is asynchronous
                            let desResult = response.result
                            if let descDict = desResult.value as? Dictionary<String, AnyObject> {
                                
                                if let description = descDict["description"] as? String {
                                    self._description = description
                                    print(self._description)
                                }
                            }
                            //When request above is done call it completed
                            completed()
                    }
                }
                
                } else {
                    //If no description create an empty one
                    self._description = ""
                }
                
                
                //This will get called before the request*
                if let evolutions = dict["evolutions"] as? [Dictionary<String,AnyObject>] where evolutions.count > 0 {
                    if let to = evolutions[0]["to"] as? String {
                        //Mega evolution is not found
                        //Can't support mega pokemon but api still has mega data
                        if to.rangeOfString("mega") == nil {
                            if let uri = evolutions[0]["resource_uri"] as? String {
                                
                                let newStr = uri.stringByReplacingOccurrencesOfString("/api/v1/pokemon/", withString: "")
                                
                                let num = newStr.stringByReplacingOccurrencesOfString("/", withString: "")
                                
                                self._nextEvolutionId = num
                                self._nextEvolutionTxt = to
                                
                                if let lvl = evolutions[0]["level"] as? Int {
                                    self._nextEvolutionLvl = "\(lvl)"
                                }
                                
                                print(self._nextEvolutionId)
                                print(self._nextEvolutionTxt)
                                print(self._nextEvolutionLvl)
                            }
                            
                        }
                    }
                }
        
        
        }
        
    }

}
}
