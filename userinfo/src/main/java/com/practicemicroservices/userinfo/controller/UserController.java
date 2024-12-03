package com.practicemicroservices.userinfo.controller;

import com.practicemicroservices.userinfo.UserInformationApplication;
import com.practicemicroservices.userinfo.dto.UserDTO;
import com.practicemicroservices.userinfo.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/user")
public class UserController {

    @Autowired
    UserService userService;

    @PostMapping("/addUser")
    public ResponseEntity<UserDTO> addUser(@RequestBody UserDTO userDTO){
        UserDTO savedUser=userService.addUser(userDTO);
        return new ResponseEntity<>(savedUser, HttpStatus.CREATED);
    }

    @GetMapping("/fetchUserById/{userId}")
    public ResponseEntity<UserDTO> getUserById(@PathVariable Integer userId){
        return userService.getUserById(userId);
    }

}
