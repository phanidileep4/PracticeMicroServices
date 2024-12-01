package com.practicemicroservices.chefListing.controller;

import com.practicemicroservices.chefListing.dto.ChefDTO;
import com.practicemicroservices.chefListing.service.ChefService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/chef")
public class ChefController {

    @Autowired
    ChefService chefService;

    @GetMapping("/fetchAllChefs")
    public ResponseEntity<List<ChefDTO>> fetchAllChefs(){
        List<ChefDTO> allChefs=chefService.findAllChefs();
        return new ResponseEntity<>(allChefs, HttpStatus.OK);
    }

    @PostMapping("/addChef")
    public ResponseEntity<ChefDTO> addChef(@RequestBody ChefDTO chefDTO){
        ChefDTO newChef=chefService.addChef(chefDTO);
        return new ResponseEntity<>(newChef,HttpStatus.CREATED);
    }

    @GetMapping("fetchById/{id}")
    public ResponseEntity<ChefDTO> findChefById(@PathVariable Integer id){
        return chefService.fetchChefById(id);
    }
}
