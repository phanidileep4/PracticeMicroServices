package com.practicemicroservices.userinfo.service;

import com.practicemicroservices.userinfo.dto.UserDTO;
import com.practicemicroservices.userinfo.entity.User;
import com.practicemicroservices.userinfo.mapper.UserMapper;
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

        public UserDTO addUser(UserDTO userDTO){
               User savedUser=userRepo.save(UserMapper.INSTANCE.mapUserDTOToUser(userDTO));
               return UserMapper.INSTANCE.mapUserTOUserDTO(savedUser);
        }

    public ResponseEntity<UserDTO> getUserById(Integer userId) {
            Optional<User> fetchedUser=userRepo.findById(userId);
        return fetchedUser.map(user -> new ResponseEntity<>(UserMapper.INSTANCE.mapUserTOUserDTO(user), HttpStatus.OK)).orElseGet(() -> new ResponseEntity<>(null, HttpStatus.NOT_FOUND));
    }
}
