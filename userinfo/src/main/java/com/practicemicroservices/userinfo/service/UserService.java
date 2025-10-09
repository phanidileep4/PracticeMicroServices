package com.practicemicroservices.userinfo.service;

import com.practicemicroservices.userinfo.dto.UserDTO;
import com.practicemicroservices.userinfo.entity.User;
import com.practicemicroservices.userinfo.repo.UserRepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
public class UserService {

    @Autowired
    UserRepo userRepo;

    public UserDTO addUser(UserDTO userDTO) {
        User savedUser = userRepo.save(mapUserDTOToUser(userDTO));
        return mapUserToUserDTO(savedUser);
    }

    public ResponseEntity<UserDTO> getUserById(String userId) {
        Optional<User> fetchedUser = userRepo.findById(userId);
        return fetchedUser.map(user -> new ResponseEntity<>(mapUserToUserDTO(user), HttpStatus.OK))
                .orElseGet(() -> new ResponseEntity<>(null, HttpStatus.NOT_FOUND));
    }

    // Manual mapping methods to replace MapStruct
    private UserDTO mapUserToUserDTO(User user) {
        UserDTO userDTO = new UserDTO();
        userDTO.setUserId(user.getUserId());
        userDTO.setUserName(user.getUserName());
        userDTO.setUserPassword(user.getUserPassword());
        userDTO.setAddress(user.getAddress());
        userDTO.setCity(user.getCity());
        return userDTO;
    }

    private User mapUserDTOToUser(UserDTO userDTO) {
        User user = new User();
        user.setUserId(userDTO.getUserId());
        user.setUserName(userDTO.getUserName());
        user.setUserPassword(userDTO.getUserPassword());
        user.setAddress(userDTO.getAddress());
        user.setCity(userDTO.getCity());
        return user;
    }
}